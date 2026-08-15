# ============================================================
# 1. IMPORT THƯ VIỆN
# ============================================================

import os
import joblib
import pandas as pd

from pathlib import Path
from dotenv import load_dotenv

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

from sqlalchemy import create_engine, text
from sqlalchemy.engine import URL

# ============================================================
# 2. KHỞI TẠO FASTAPI APP
# ============================================================

app = FastAPI(
    title="Credit Risk Prediction API",
    description="API phân loại và dự báo rủi ro khách hàng vay vốn.",
    version="1.0.0",
)

# ============================================================
# 3. KẾT NỐI DATABASE
# ============================================================

env_path = Path(__file__).resolve().parent.parent / ".env"

if not env_path.exists():
    raise FileNotFoundError("Không tìm thấy file .env.")

load_dotenv(env_path)

db_url = URL.create(
    drivername="postgresql+psycopg2",
    username=os.getenv("DB_USER", "postgres"),
    password=os.getenv("DB_PASSWORD"),
    host=os.getenv("DB_HOST", "localhost"),
    port=int(os.getenv("DB_PORT", "5432")),
    database=os.getenv("DB_NAME", "credit_risk_db"),
)

engine = create_engine(
    db_url,
    pool_pre_ping=True,
)

try:
    with engine.connect() as connection:
        result = connection.execute(text("SELECT current_database();"))
        print(f"Kết nối database thành công: {result.scalar()}")

except Exception as error:
    print(f"Lỗi kết nối database: {error}")

# ============================================================
# 4. LOAD MODEL VÀ NẠP DANH SÁCH FEATURES
# ============================================================

# Đường dẫn tới file model.
model_path = (
    Path(__file__).resolve().parent.parent
    / "models"
    / "hist_gradient_boosting_threshold_optimized.pkl"
)

if not model_path.exists():
    raise FileNotFoundError(
        f"Không tìm thấy file model: {model_path}"
    )

# Load model package đã lưu từ Notebook 06.1.
model_package = joblib.load(model_path)

# Tách các thành phần cần dùng.
model = model_package["model"]
decision_threshold = model_package["decision_threshold"]
feature_names = model_package["feature_names"]
numeric_columns = model_package["numeric_columns"]
categorical_columns = model_package["categorical_columns"]
train_median = model_package["train_median"]
dropped_interactions = model_package["dropped_interactions"]

# Kiểm tra nhanh model sau khi load.
print("Load model thành công.")
print(f"Model: {type(model).__name__}")
print(f"Số feature: {len(feature_names)}")
print(f"Decision threshold: {decision_threshold}")


# ============================================================
# 5. PYDANTIC SCHEMAS
# ============================================================


# Request dự đoán cho một khách hàng.
class PredictionRequest(BaseModel):
    sk_id_curr: int


# Response kết quả dự đoán cho một khách hàng.
class PredictionResponse(BaseModel):
    sk_id_curr: int
    prediction: int
    risk_label: str
    risk_probability: float
    decision_threshold: float


# Request dự đoán cho nhiều khách hàng.
class BatchPredictionRequest(BaseModel):
    sk_id_curr_list: list[int]


# Response dự đoán theo lô.
class BatchPredictionResponse(BaseModel):
    total: int
    predictions: list[PredictionResponse]


# ============================================================
# 6. HELPER FUNCTIONS
# ============================================================


def get_customer_data(sk_id_curr: int) -> pd.DataFrame:
    """
    Lấy dữ liệu feature của một khách hàng từ application_features.
    """

    query = text("""
        SELECT *
        FROM public.application_features
        WHERE sk_id_curr = :sk_id_curr
    """)

    with engine.connect() as connection:
        customer_df = pd.read_sql(
            query,
            connection,
            params={"sk_id_curr": sk_id_curr},
        )

    if customer_df.empty:
        raise HTTPException(
            status_code=404,
            detail=f"Không tìm thấy khách hàng có sk_id_curr = {sk_id_curr}.",
        )

    return customer_df


def preprocess_features(customer_df: pd.DataFrame) -> pd.DataFrame:
    """
    Tiền xử lý dữ liệu theo đúng quy trình đã sử dụng khi huấn luyện model.
    """

    data = customer_df.copy()

    # Không đưa ID và target vào model.
    data = data.drop(
        columns=["sk_id_curr", "target"],
        errors="ignore",
    )

    # Loại các interaction đã được loại trước khi train model.
    data = data.drop(
        columns=dropped_interactions,
        errors="ignore",
    )

    # Đảm bảo các cột cần thiết tồn tại.
    for column in numeric_columns:
        if column not in data.columns:
            data[column] = pd.NA

    for column in categorical_columns:
        if column not in data.columns:
            data[column] = "Unknown"

    # Xử lý missing cho biến số bằng median của Train.
    for column in numeric_columns:
        data[column] = pd.to_numeric(
            data[column],
            errors="coerce",
        )
        data[column] = data[column].fillna(
            train_median[column]
        )

    # Xử lý missing cho biến phân loại.
    for column in categorical_columns:
        data[column] = (
            data[column]
            .astype("string")
            .fillna("Unknown")
        )

    # One-hot encoding giống Notebook 06.1.
    data = pd.get_dummies(
        data,
        columns=categorical_columns,
        dtype=int,
    )

    # Căn lại chính xác 360 feature và đúng thứ tự khi train.
    data = data.reindex(
        columns=feature_names,
        fill_value=0,
    )

    return data


def predict_customer(sk_id_curr: int) -> dict:
    """
    Dự đoán rủi ro tín dụng cho một khách hàng.
    """

    customer_df = get_customer_data(sk_id_curr)

    processed_data = preprocess_features(customer_df)

    # Xác suất khách hàng thuộc target = 1.
    risk_probability = float(
        model.predict_proba(processed_data)[0, 1]
    )

    # Áp dụng threshold đã tối ưu trên Validation.
    prediction = int(
        risk_probability >= decision_threshold
    )

    risk_label = (
        "Nợ xấu"
        if prediction == 1
        else "Trả được nợ"
    )

    return {
        "sk_id_curr": sk_id_curr,
        "prediction": prediction,
        "risk_label": risk_label,
        "risk_probability": round(risk_probability, 4),
        "decision_threshold": round(float(decision_threshold), 2),
    }

# ============================================================
# 7. API ENDPOINTS
# ============================================================


@app.get("/")
def root():
    """
    Trang chủ của API.
    """
    return {
        "message": "Credit Risk Prediction API",
        "status": "running",
        "docs": "/docs",
    }


@app.get("/health")
def health_check():
    """
    Kiểm tra trạng thái API, database và model.
    """
    try:
        with engine.connect() as connection:
            connection.execute(text("SELECT 1"))

        database_status = "connected"

    except Exception:
        database_status = "disconnected"

    return {
        "status": "healthy",
        "database": database_status,
        "model": type(model).__name__,
        "features_count": len(feature_names),
        "decision_threshold": round(float(decision_threshold), 2),
    }


@app.post("/predict", response_model=PredictionResponse)
def predict(request: PredictionRequest):
    """
    Dự đoán rủi ro cho một khách hàng.
    """
    return predict_customer(request.sk_id_curr)


@app.post("/predict_batch", response_model=BatchPredictionResponse)
def predict_batch(request: BatchPredictionRequest):
    """
    Dự đoán rủi ro cho nhiều khách hàng.
    """
    predictions = []

    for sk_id_curr in request.sk_id_curr_list:
        try:
            result = predict_customer(sk_id_curr)
            predictions.append(result)

        except HTTPException:
            continue

    return {
        "total": len(predictions),
        "predictions": predictions,
    }


@app.get("/applications")
def get_applications(limit: int = 20, offset: int = 0):
    """
    Lấy danh sách hồ sơ khách hàng.
    """
    if limit < 1 or limit > 100:
        raise HTTPException(
            status_code=400,
            detail="limit phải nằm trong khoảng từ 1 đến 100.",
        )

    if offset < 0:
        raise HTTPException(
            status_code=400,
            detail="offset không được nhỏ hơn 0.",
        )

    query = text("""
        SELECT
            sk_id_curr,
            target,
            name_contract_type,
            code_gender,
            amt_income_total,
            amt_credit,
            amt_annuity,
            name_income_type,
            name_education_type
        FROM public.application_features
        ORDER BY sk_id_curr
        LIMIT :limit
        OFFSET :offset
    """)

    with engine.connect() as connection:
        result = connection.execute(
            query,
            {
                "limit": limit,
                "offset": offset,
            },
        )

        applications = [
            dict(row._mapping)
            for row in result
        ]

    return {
        "limit": limit,
        "offset": offset,
        "count": len(applications),
        "applications": applications,
    }


@app.get("/applications/{sk_id_curr}")
def get_application(sk_id_curr: int):
    """
    Lấy thông tin chi tiết của một khách hàng.
    """
    customer_df = get_customer_data(sk_id_curr)

    customer_data = (
        customer_df
        .replace({pd.NA: None})
        .iloc[0]
        .to_dict()
    )

    return customer_data


@app.get("/dashboard")
def get_dashboard():
    """
    Lấy các chỉ số tổng quan phục vụ Dashboard.
    """
    query = text("""
        SELECT
            COUNT(*) AS total_customers,
            COUNT(*) FILTER (WHERE target = 0) AS good_customers,
            COUNT(*) FILTER (WHERE target = 1) AS bad_customers,
            AVG(amt_income_total) AS avg_income,
            AVG(amt_credit) AS avg_credit,
            AVG(amt_annuity) AS avg_annuity
        FROM public.application_features
    """)

    with engine.connect() as connection:
        row = connection.execute(query).mappings().one()

    total_customers = int(row["total_customers"] or 0)
    good_customers = int(row["good_customers"] or 0)
    bad_customers = int(row["bad_customers"] or 0)

    bad_customer_rate = (
        bad_customers / total_customers
        if total_customers > 0
        else 0
    )

    return {
        "total_customers": total_customers,
        "good_customers": good_customers,
        "bad_customers": bad_customers,
        "bad_customer_rate": round(bad_customer_rate, 4),
        "avg_income": round(float(row["avg_income"] or 0), 2),
        "avg_credit": round(float(row["avg_credit"] or 0), 2),
        "avg_annuity": round(float(row["avg_annuity"] or 0), 2),
    }

# ============================================================
# 8. RUN SERVER
# ============================================================

if __name__ == "__main__":
    import uvicorn

    uvicorn.run(
        "api:app",
        host="127.0.0.1",
        port=8000,
        reload=True,
    )