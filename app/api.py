# ============================================================
# 1. IMPORT THƯ VIỆN
# ============================================================

import os
import joblib
import pandas as pd
import numpy as np

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

constant_columns = model_package["constant_columns"]
history_zero_fill_columns = model_package["history_zero_fill_columns"]

numeric_columns = model_package["numeric_columns"]
categorical_columns = model_package["categorical_columns"]

numeric_imputer = model_package["numeric_imputer"]
categorical_imputer = model_package["categorical_imputer"]
encoder = model_package["encoder"]

interaction_features = model_package["interaction_features"]

income_bins = model_package["income_bins"]
debt_bins = model_package["debt_bins"]

age_bins = model_package["age_bins"]
age_labels = model_package["age_labels"]
income_labels = model_package["income_labels"]
debt_labels = model_package["debt_labels"]

late_payment_columns = model_package["late_payment_columns"]
missing_label = model_package["missing_label"]

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
    Tiền xử lý dữ liệu theo đúng pipeline đã sử dụng khi huấn luyện model.
    """

    data = customer_df.copy()

    # --------------------------------------------------------
    # 1. Loại ID và target
    # --------------------------------------------------------
    data = data.drop(
        columns=["sk_id_curr", "target"],
        errors="ignore",
    )

    # --------------------------------------------------------
    # 2. Loại các interaction cũ nếu có
    # --------------------------------------------------------
    data = data.drop(
        columns=interaction_features,
        errors="ignore",
    )

    # --------------------------------------------------------
    # 3. Loại các cột hằng số giống lúc train
    # --------------------------------------------------------
    data = data.drop(
        columns=constant_columns,
        errors="ignore",
    )

    # --------------------------------------------------------
    # 4. Tạo lại interaction features
    # --------------------------------------------------------

    # Age × Income
    nhom_tuoi = pd.cut(
        data["age_years"],
        bins=age_bins,
        labels=age_labels,
    )

    nhan_thu_nhap = income_labels[
        : len(income_bins) - 1
    ]

    nhom_thu_nhap = pd.cut(
        data["amt_income_total"],
        bins=income_bins,
        labels=nhan_thu_nhap,
    )

    age_income = (
        nhom_tuoi.astype("string")
        + " | "
        + nhom_thu_nhap.astype("string")
    )

    data["age_income_interaction"] = (
        age_income.fillna(missing_label)
    )

    # Late Payment × Debt
    tung_tre = (
        data[late_payment_columns]
        .fillna(0)
        .gt(0)
        .any(axis=1)
    )

    nhom_tre = pd.Series(
        [
            "Từng trễ"
            if value
            else "Không ghi nhận trễ"
            for value in tung_tre
        ],
        index=data.index,
        dtype="string",
    )

    du_no = data["bureau_sum_debt"]

    nhom_du_no = pd.Series(
        missing_label,
        index=data.index,
        dtype="string",
    )

    nhom_du_no.loc[
        du_no == 0
    ] = "Không còn dư nợ"

    co_du_no = du_no > 0

    nhan_du_no = debt_labels[
        : len(debt_bins) - 1
    ]

    nhom_du_no.loc[co_du_no] = pd.cut(
        du_no.loc[co_du_no],
        bins=debt_bins,
        labels=nhan_du_no,
    ).astype("string")

    data["late_debt_interaction"] = (
        nhom_tre
        + " | "
        + nhom_du_no
    )

    if "has_bureau" in data.columns:
        data.loc[
            data["has_bureau"].fillna(0) == 0,
            "late_debt_interaction",
        ] = missing_label

    # --------------------------------------------------------
    # 5. Điền 0 theo lịch sử
    # --------------------------------------------------------
    for flag, columns in history_zero_fill_columns.items():
        if flag not in data.columns:
            continue

        khong_co_lich_su = data[flag] == 0

        existing_columns = [
            column
            for column in columns
            if column in data.columns
        ]

        data.loc[
            khong_co_lich_su,
            existing_columns,
        ] = (
            data.loc[
                khong_co_lich_su,
                existing_columns,
            ]
            .fillna(0)
        )

    # --------------------------------------------------------
    # 6. Bổ sung cột thiếu nếu cần
    # --------------------------------------------------------
    for column in numeric_columns:
        if column not in data.columns:
            data[column] = pd.NA

    for column in categorical_columns:
        if column not in data.columns:
            data[column] = pd.NA

    # --------------------------------------------------------
    # 7. Impute numerical
    # --------------------------------------------------------
    data_num = pd.DataFrame(
        numeric_imputer.transform(
            data[numeric_columns]
        ),
        columns=numeric_columns,
        index=data.index,
    )

    # --------------------------------------------------------
    # 8. Impute categorical
    # --------------------------------------------------------
    data_cat_input = (
        data[categorical_columns]
        .astype(object)
    )

    data_cat_input = data_cat_input.where(
        data_cat_input.notna(),
        pd.NA,
    )

    data_cat = pd.DataFrame(
        categorical_imputer.transform(
            data_cat_input
        ),
        columns=categorical_columns,
        index=data.index,
    )

    # --------------------------------------------------------
    # 9. One-hot encoding bằng encoder đã fit lúc train
    # --------------------------------------------------------
    encoded_columns = encoder.get_feature_names_out(
        categorical_columns
    )

    encoded = pd.DataFrame(
        encoder.transform(data_cat),
        columns=encoded_columns,
        index=data.index,
    )

    # --------------------------------------------------------
    # 10. Ghép numerical + encoded
    # --------------------------------------------------------
    processed_data = pd.concat(
        [
            data_num,
            encoded,
        ],
        axis=1,
    )

    # --------------------------------------------------------
    # 11. Căn đúng feature và đúng thứ tự như lúc train
    # --------------------------------------------------------
    processed_data = processed_data.reindex(
        columns=feature_names,
        fill_value=0,
    )

    return processed_data


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