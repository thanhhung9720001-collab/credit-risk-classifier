# credit-risk-classifier

**Xây dựng Mô hình Phân loại và Dự báo Rủi ro Khách hàng Vay vốn**

Đồ án môn **Dự án 1** — FPT Polytechnic, Block 2, HK Summer 2026 — Nhóm 01.

---

## 1. Giới thiệu đề tài

Dự án xây dựng một pipeline AI dự đoán khả năng khách hàng vay gặp khó khăn trong việc trả nợ, sử dụng bộ dữ liệu **Home Credit Default Risk** trên Kaggle.

Dữ liệu từ hồ sơ vay hiện tại và các bảng lịch sử được tổ chức trong PostgreSQL, tổng hợp về cấp khách hàng, làm sạch, tạo đặc trưng, huấn luyện mô hình, tối ưu ngưỡng phân loại và triển khai ứng dụng demo bằng FastAPI + Streamlit.

| Nội dung | Mô tả |
|---|---|
| **Bài toán** | Phân loại nhị phân: `TARGET = 1` nếu khách hàng gặp khó khăn trong việc trả nợ, `TARGET = 0` nếu không |
| **Dữ liệu** | 8 bảng dữ liệu, khoảng 2,5 GB; bảng huấn luyện trung tâm có **307.511 dòng × 122 cột** |
| **Thách thức** | Quan hệ một-nhiều, dữ liệu thiếu, outlier, giá trị không hợp lệ và lớp nợ xấu chỉ chiếm khoảng **8,09%** |
| **Mô hình được chọn** | `HistGradientBoostingClassifier` |
| **Kết quả chính** | ROC-AUC **0,7780** ở bước so sánh mô hình; ngưỡng tối ưu F1 là **0,67** |
| **Backend** | FastAPI |
| **Giao diện demo** | Streamlit |
| **Cơ sở dữ liệu** | PostgreSQL |
| **Công nghệ chính** | Python 3.11, pandas, NumPy, scikit-learn, SciPy, FastAPI, Streamlit |

Do dữ liệu mất cân bằng, dự án không lựa chọn mô hình chỉ dựa trên Accuracy.

Các chỉ số đánh giá chính gồm:

- ROC-AUC
- PR-AUC
- Precision
- Recall
- F1-score

---

## 2. Cấu trúc thư mục

```text
credit-risk-classifier/
├── notebooks/                         # Pipeline phân tích và mô hình hóa
│   ├── 00_business_understanding.ipynb
│   ├── 01_data_understanding.ipynb
│   ├── 02_database_organization.ipynb
│   ├── 03_data_cleaning.ipynb
│   ├── 04_eda_visualization.ipynb
│   ├── 05_feature_engineering.ipynb
│   ├── 06_modeling_evaluation.ipynb
│   └── 06_1_threshold_optimization.ipynb
│
├── sql/                               # Script PostgreSQL, chạy theo thứ tự
│   ├── 01_create_tables.sql
│   ├── 02_import_data.sql
│   ├── 03_check_import_counts.sql
│   ├── 04_check_column_types.sql
│   ├── 05_create_indexes.sql
│   ├── 06_create_summary_tables.sql
│   ├── 07_check_summary_grain.sql
│   ├── 08_create_application_flat.sql
│   ├── 09_check_flat_rows.sql
│   ├── 10_check_flat_target.sql
│   └── 11_check_flat_nulls.sql
│
├── app/                               # Ứng dụng dự đoán
│   ├── api.py                         # FastAPI backend
│   └── stream_app.py                  # Giao diện Streamlit
│
├── data/
│   ├── raw/                           # CSV gốc từ Kaggle, không commit
│   ├── processed/                     # Dữ liệu trung gian, không commit
│   └── sample/
│
├── models/                            # Artifact mô hình
│
├── reports/
│   └── images/
│       └── home_credit_erd.png
│
├── docs/                              # Báo cáo và tài liệu dự án
├── context/                           # Ghi chú tiến độ từng thành viên
│
├── PROJECT_CONTEXT.md                 # Trạng thái tổng thể dự án
├── requirements.txt                   # Dependency Python
└── README.md
```

> `data/`, `.env`, `.venv/` và phần lớn artifact trong `models/` không được commit lên Git.
>
> Máy mới cần tải dữ liệu, cấu hình PostgreSQL, tạo môi trường Python và có đúng artifact mô hình trước khi chạy đầy đủ hệ thống.

---

# 3. Yêu cầu môi trường

| Thành phần | Phiên bản/điều kiện | Ghi chú |
|---|---|---|
| **Python** | **3.11.x** | Bắt buộc sử dụng Python 3.11 cho môi trường ảo của dự án |
| **PostgreSQL** | 14+ | Dùng làm nguồn dữ liệu trung tâm |
| **RAM** | Tối thiểu 8 GB | Nên đóng ứng dụng nặng khi chạy toàn bộ pipeline |
| **Ổ cứng** | Tối thiểu 7 GB trống | Dành cho dữ liệu, PostgreSQL, `.venv` và artifact |
| **Git** | Phiên bản hiện hành | Dùng để quản lý source code |

Dự án hiện được kiểm thử với:

```text
Python 3.11.9
```

## Lưu ý về phiên bản Python

Máy cá nhân có thể cài nhiều phiên bản Python cùng lúc.

Ví dụ, máy có thể đồng thời có:

```text
Python 3.11
Python 3.13
Python 3.14
```

Không cần gỡ các phiên bản Python khác.

Tuy nhiên, môi trường ảo `.venv` của **credit-risk-classifier** phải được tạo bằng:

```text
Python 3.11.x
```

Điều này giúp bảo đảm khả năng tương thích giữa các thư viện Machine Learning và các package có binary dependency như:

- NumPy
- SciPy
- scikit-learn
- psycopg2
- greenlet
- SQLAlchemy

---

# 4. Cài đặt dự án

## 4.1. Kiểm tra Python 3.11

Trên Windows PowerShell:

```powershell
py -0p
```

Ví dụ:

```text
-V:3.14    D:\pyenv\python.exe
-V:3.13    C:\...\Python3.13\python.exe
-V:3.11    C:\...\Python311\python.exe
```

Kiểm tra Python 3.11:

```powershell
py -3.11 --version
```

Kết quả mong đợi:

```text
Python 3.11.x
```

### Nếu máy chưa có Python 3.11

Có thể cài bằng Windows Package Manager:

```powershell
winget install Python.Python.3.11
```

Sau khi cài xong, đóng PowerShell và mở lại.

Kiểm tra:

```powershell
py -3.11 --version
```

> Không cần gỡ Python 3.12, 3.13, 3.14 hoặc phiên bản Python khác đang có trên máy.

---

## 4.2. Clone repository

```powershell
git clone https://github.com/thanhhung9720001-collab/credit-risk-classifier.git
```

Di chuyển vào thư mục dự án:

```powershell
cd credit-risk-classifier
```

---

## 4.3. Tạo môi trường ảo

Tạo `.venv` bằng đúng Python 3.11:

```powershell
py -3.11 -m venv .venv
```

Kích hoạt môi trường:

```powershell
.\.venv\Scripts\Activate.ps1
```

Sau khi kích hoạt thành công, terminal sẽ có dạng:

```text
(.venv) PS ...\credit-risk-classifier>
```

Kiểm tra:

```powershell
python --version
```

Kết quả phải là:

```text
Python 3.11.x
```

> Không nên sử dụng `python -m venv .venv` nếu chưa kiểm tra Python mặc định của máy, vì lệnh đó có thể tạo môi trường bằng Python 3.13 hoặc 3.14.

---

## 4.4. Cài thư viện

Nâng cấp pip:

```powershell
python -m pip install --upgrade pip
```

Cài dependency:

```powershell
python -m pip install -r requirements.txt
```

Kiểm tra môi trường:

```powershell
python -m pip check
```

Kết quả mong đợi:

```text
No broken requirements found.
```

Một số dependency chính của dự án:

```text
pandas==3.0.3
numpy==2.4.6
psycopg2-binary==2.9.12
SQLAlchemy==2.0.52
greenlet==3.5.5

matplotlib==3.10.9
seaborn==0.13.2

scikit-learn==1.8.0
scipy==1.17.1
joblib==1.5.3

fastapi==0.141.1
uvicorn==0.52.3
pydantic==2.13.4

streamlit==1.58.0
requests==2.34.2

ipykernel==7.2.0
```

---

## 4.5. Chạy Notebook

`ipykernel` trong `requirements.txt` đủ để chạy notebook bằng VS Code.

Trong VS Code, chọn Python Interpreter/Kernel từ:

```text
.venv
```

Nếu muốn chạy JupyterLab trên trình duyệt:

```powershell
pip install jupyterlab
```

Sau đó:

```powershell
jupyter lab
```

---

## 4.6. Tải dữ liệu Home Credit

Tải bộ dữ liệu **Home Credit Default Risk** từ Kaggle:

https://www.kaggle.com/competitions/home-credit-default-risk/data

Giải nén và đặt các file cần thiết vào:

```text
data/raw/
```

Cấu trúc:

```text
data/raw/
├── application_train.csv
├── application_test.csv
├── bureau.csv
├── bureau_balance.csv
├── previous_application.csv
├── installments_payments.csv
├── credit_card_balance.csv
├── POS_CASH_balance.csv
└── HomeCredit_columns_description.csv
```

Các file dữ liệu lớn không được commit lên Git.

---

## 4.7. Cấu hình PostgreSQL

Tạo file `.env` từ file mẫu:

```powershell
Copy-Item .env.example .env
```

Cập nhật thông tin kết nối:

```ini
DB_HOST=localhost
DB_PORT=5432
DB_NAME=credit_risk_db
DB_USER=postgres
DB_PASSWORD=mat_khau_cua_ban
```

Tạo database:

```sql
CREATE DATABASE credit_risk_db;
```

> Không commit `.env` hoặc mật khẩu PostgreSQL lên Git.

---

# 5. Thứ tự chạy pipeline

Pipeline sử dụng PostgreSQL làm nguồn dữ liệu trung tâm và cần chạy tuần tự:

```text
data/raw/*.csv
      │
      ├── NB00
      │   Business Understanding
      │
      ├── NB01
      │   Data Understanding
      │
      ▼
NB02 — Database Organization
      │
      └── application_flat
          307.511 × 180
              │
              ▼
NB03 — Data Cleaning
      │
      └── application_flat_cleaned
          306.195 × 188
              │
              ▼
NB04 — EDA & Visualization
              │
              ▼
NB05 — Feature Engineering
      │
      └── application_features
          306.195 × 234
              │
              ▼
NB06 — Modeling & Evaluation
      │
      ├── Logistic Regression
      ├── Random Forest
      └── HistGradientBoosting
              │
              ▼
NB06.1 — Threshold Optimization
      │
      ├── Preprocessing: 360 features
      ├── Model artifact
      └── Decision threshold = 0.67
              │
              ▼
FastAPI
      │
      ▼
Streamlit
```

| Notebook | Đầu vào chính | Kết quả chính |
|---|---|---|
| **NB00** | Đề bài và bối cảnh nghiệp vụ | Bài toán, SWOT và mục tiêu nghiên cứu |
| **NB01** | Dữ liệu trong `data/raw/` | Tổng quan dữ liệu, khóa liên kết và chất lượng dữ liệu |
| **NB02** | CSV, PostgreSQL, `.env` | 8 bảng raw, bảng tổng hợp, index và `application_flat` **307.511 × 180** |
| **NB03** | `application_flat` | `application_flat_cleaned` **306.195 × 188** |
| **NB04** | `application_flat_cleaned` | EDA, insight và đề xuất feature |
| **NB05** | `application_flat_cleaned` | 46 feature mới; `application_features` **306.195 × 234** |
| **NB06** | `application_features` | So sánh Logistic Regression, Random Forest và HistGradientBoosting |
| **NB06.1** | `application_features` | Preprocessing 360 feature, chọn threshold 0,67 và lưu artifact |

NB05 tạo 46 feature theo 7 nhóm.

Trong đó, 44 feature được bàn giao trực tiếp; `age_income_interaction` và `late_debt_interaction` được tính lại từ tập Train trong NB06 để tránh data leakage.

---

# 6. Kết quả mô hình

## 6.1. So sánh mô hình tại ngưỡng 0,5

| Mô hình | ROC-AUC | PR-AUC | Precision | Recall | F1-score |
|---|---:|---:|---:|---:|---:|
| Logistic Regression | 0,7714 | 0,2544 | 0,1741 | **0,6994** | 0,2788 |
| Random Forest | 0,7600 | 0,2424 | **0,1890** | 0,6163 | 0,2893 |
| **HistGradientBoosting** | **0,7780** | **0,2717** | 0,1840 | 0,6871 | **0,2903** |

HistGradientBoosting được chọn vì dẫn đầu đồng thời:

- ROC-AUC
- PR-AUC
- F1-score

trong lần đánh giá mô hình.

---

## 6.2. Tối ưu ngưỡng

NB06.1 chia dữ liệu theo tỷ lệ xấp xỉ:

```text
64% Train
16% Validation
20% Test
```

Ngưỡng được lựa chọn trên Validation trước khi đánh giá Test.

Ngưỡng tối ưu:

```text
0.67
```

Kết quả trên Test:

| Chỉ số | Kết quả |
|---|---:|
| Precision | 0,2630 |
| Recall | 0,4396 |
| F1-score | **0,3292** |
| True Negative | 50.183 |
| False Positive | 6.102 |
| False Negative | 2.776 |
| True Positive | 2.178 |

Ngưỡng `0.67` làm Precision và F1-score tăng so với ngưỡng mặc định `0.5`, nhưng Recall giảm.

Đây là sự đánh đổi cần được xem xét khi ứng dụng mô hình vào nghiệp vụ thực tế.

---

# 7. FastAPI Backend

Backend của hệ thống được triển khai bằng **FastAPI**.

File:

```text
app/api.py
```

FastAPI đảm nhiệm:

- Kết nối PostgreSQL.
- Load artifact mô hình.
- Load preprocessing.
- Nhận mã khách hàng.
- Lấy feature từ database.
- Thực hiện `predict_proba()`.
- Phân loại bằng threshold `0.67`.
- Trả kết quả cho Streamlit.

## 7.1. Chạy FastAPI

Từ thư mục gốc:

```powershell
.\.venv\Scripts\Activate.ps1
```

Di chuyển vào:

```powershell
cd app
```

Chạy:

```powershell
python api.py
```

Nếu thành công:

```text
Kết nối database thành công: credit_risk_db
Load model thành công.
Model: HistGradientBoostingClassifier
Số feature: 360
Decision threshold: 0.67

Uvicorn running on http://127.0.0.1:8000
```

FastAPI:

```text
http://127.0.0.1:8000
```

Swagger UI:

```text
http://127.0.0.1:8000/docs
```

---

## 7.2. Các endpoint chính

| Method | Endpoint | Chức năng |
|---|---|---|
| `GET` | `/` | Kiểm tra API |
| `GET` | `/health` | Kiểm tra trạng thái API/model |
| `POST` | `/predict` | Dự đoán một khách hàng |
| `POST` | `/predict_batch` | Dự đoán nhiều khách hàng |
| `GET` | `/applications` | Lấy danh sách khách hàng |
| `GET` | `/applications/{sk_id_curr}` | Tra cứu chi tiết khách hàng |
| `GET` | `/dashboard` | Lấy dữ liệu tổng quan cho dashboard |

---

# 8. Streamlit Application

Giao diện người dùng được xây dựng bằng **Streamlit**.

File:

```text
app/stream_app.py
```

Ứng dụng giao tiếp với FastAPI thay vì trực tiếp thực hiện dự đoán.

Các chức năng hiện tại gồm:

1. Dashboard tổng quan.
2. Dự đoán rủi ro một khách hàng.
3. Dự đoán nhiều khách hàng theo lô.
4. Tra cứu thông tin khách hàng.
5. Hiển thị xác suất rủi ro.
6. Phân loại theo threshold `0.67`.
7. Hiển thị dữ liệu khách hàng với tên feature tiếng Việt.

---

## 8.1. Chạy ứng dụng hoàn chỉnh

Cần sử dụng **hai terminal**.

### Terminal 1 — FastAPI

Từ thư mục gốc:

```powershell
.\.venv\Scripts\Activate.ps1
cd app
python api.py
```

FastAPI chạy tại:

```text
http://127.0.0.1:8000
```

Giữ terminal này hoạt động.

---

### Terminal 2 — Streamlit

Mở terminal mới tại thư mục gốc:

```powershell
.\.venv\Scripts\Activate.ps1
cd app
streamlit run stream_app.py
```

Streamlit mặc định chạy tại:

```text
http://localhost:8501
```

Trình duyệt sẽ tự động mở giao diện ứng dụng.

---

## 8.2. Kiến trúc ứng dụng

```text
┌─────────────────────┐
│      Streamlit      │
│   stream_app.py     │
└──────────┬──────────┘
           │
           │ HTTP / JSON
           ▼
┌─────────────────────┐
│       FastAPI       │
│       api.py        │
└──────────┬──────────┘
           │
           ├──────────────► PostgreSQL
           │
           │
           └──────────────► ML Model
                              │
                              ▼
                    HistGradientBoosting
                    Threshold = 0.67
```

Streamlit không truy cập trực tiếp mô hình.

Luồng xử lý:

```text
Người dùng
    ↓
Streamlit
    ↓
FastAPI
    ↓
PostgreSQL
    ↓
Preprocessing
    ↓
HistGradientBoosting
    ↓
predict_proba()
    ↓
Threshold 0.67
    ↓
FastAPI response
    ↓
Streamlit
```

---

# 9. Trạng thái dự án

| Hạng mục | Trạng thái |
|---|---|
| SQL `01` → `11` | Hoàn thành |
| Notebook `00` → `06.1` | Hoàn thành |
| Data Cleaning | Hoàn thành |
| EDA | Hoàn thành |
| Feature Engineering | Hoàn thành |
| Model Training | Hoàn thành |
| Model Evaluation | Hoàn thành |
| Threshold Optimization | Hoàn thành |
| HistGradientBoosting artifact | Hoàn thành cục bộ |
| FastAPI Backend | Hoàn thành |
| API dự đoán đơn | Hoàn thành |
| API dự đoán theo lô | Hoàn thành |
| API tra cứu khách hàng | Hoàn thành |
| API Dashboard | Hoàn thành |
| Streamlit Dashboard | Hoàn thành |
| Streamlit dự đoán đơn | Hoàn thành |
| Streamlit dự đoán theo lô | Hoàn thành |
| Streamlit tra cứu khách hàng | Hoàn thành |
| Báo cáo Word | Đang cập nhật |
| Slide bảo vệ | Đang cập nhật |

---

# 10. Lưu ý kỹ thuật

## 10.1. PostgreSQL `COPY` ghép dữ liệu theo vị trí cột

Tên cột giống nhau chưa đủ bảo đảm import đúng.

Khi sử dụng `COPY`, cần kiểm tra:

- Số lượng cột.
- Thứ tự cột.
- Kiểu dữ liệu.
- Header CSV.

Nên khai báo danh sách cột rõ ràng và chạy các script kiểm tra sau import.

---

## 10.2. Tổng hợp bảng một-nhiều trước khi join

Các bảng lịch sử có nhiều dòng cho một khách hàng.

Phải tổng hợp về grain:

```text
SK_ID_CURR
```

trước khi join để tránh nhân bản dòng.

Riêng:

```text
bureau_balance
```

không có `SK_ID_CURR`.

Do đó cần:

```text
bureau_balance
      ↓
aggregate theo SK_ID_BUREAU
      ↓
join bureau
      ↓
aggregate theo SK_ID_CURR
```

---

## 10.3. Không ép khóa ngoại khi dữ liệu nguồn có bản ghi mồ côi

Bộ dữ liệu Kaggle được tách theo mục đích thi nên một số quan hệ không bảo đảm toàn vẹn tham chiếu tuyệt đối.

Pipeline sử dụng:

- Kiểm tra dữ liệu.
- Index.
- Validation query.

thay vì cưỡng ép khóa ngoại khiến quá trình import thất bại.

---

## 10.4. Không điền toàn bộ giá trị thiếu bằng một quy tắc

Một số `NaN` mang ý nghĩa khách hàng không có loại lịch sử tương ứng.

Cần đọc cùng các feature như:

```text
has_bureau
has_previous
has_installments
has_pos_cash
has_credit_card
```

Không nên biến trạng thái "không có dữ liệu" thành `0` nếu không có căn cứ nghiệp vụ.

---

## 10.5. Ngăn Data Leakage

Mọi tham số phụ thuộc dữ liệu phải được học từ Train, bao gồm:

- Median.
- Encoding.
- Category.
- Quantile threshold.
- Feature transformation.

Hai feature:

```text
age_income_interaction
late_debt_interaction
```

được tính lại từ Train trong NB06 để tránh data leakage.

---

## 10.6. Restart Kernel và Run All trước khi commit Notebook

Không dựa vào biến còn sót trong kernel.

Trước khi commit notebook:

1. Restart Kernel.
2. Run All.
3. Kiểm tra `execution_count`.
4. Kiểm tra output lỗi.
5. Kiểm tra nhận xét có khớp kết quả thực tế hay không.

Không nên sử dụng:

```python
warnings.filterwarnings("ignore")
```

toàn cục vì có thể che các cảnh báo quan trọng.

---

## 10.7. Ứng dụng phải sử dụng threshold 0.67

Ứng dụng phải lấy xác suất:

```python
model.predict_proba(...)
```

sau đó phân loại theo:

```text
threshold = 0.67
```

Không sử dụng:

```python
model.predict(...)
```

với threshold mặc định `0.5` nếu muốn tái hiện kết quả đã tối ưu trong NB06.1.

Quy tắc:

```text
risk_probability >= 0.67
        ↓
TARGET = 1
        ↓
Nợ xấu
```

Ngược lại:

```text
risk_probability < 0.67
        ↓
TARGET = 0
        ↓
Trả được nợ
```

---

## 10.8. Artifact mô hình không đi theo Git

Các artifact mô hình được tạo cục bộ trong:

```text
models/
```

và phần lớn được `.gitignore`.

Máy mới cần:

- Chạy lại pipeline tạo model; hoặc
- Nhận đúng artifact từ thành viên phụ trách.

Artifact phải tương ứng với:

- Model.
- Preprocessing.
- Danh sách feature.
- Phiên bản thư viện.
- Threshold.

---

## 10.9. Không commit môi trường ảo

Không commit:

```text
.venv/
```

Mỗi thành viên tự tạo môi trường:

```powershell
py -3.11 -m venv .venv
```

sau đó:

```powershell
python -m pip install -r requirements.txt
```

---

# 11. Xử lý một số lỗi thường gặp

## 11.1. Sai phiên bản Python

Kiểm tra:

```powershell
python --version
```

Nếu không phải `3.11.x`, xóa `.venv` và tạo lại:

```powershell
deactivate
Remove-Item -Recurse -Force .venv
py -3.11 -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install -r requirements.txt
```

---

## 11.2. Kiểm tra dependency

```powershell
python -m pip check
```

Kết quả đúng:

```text
No broken requirements found.
```

---

## 11.3. FastAPI không kết nối PostgreSQL

Kiểm tra:

1. PostgreSQL đang chạy.
2. Database `credit_risk_db` tồn tại.
3. File `.env` tồn tại.
4. `DB_USER` đúng.
5. `DB_PASSWORD` đúng.
6. `DB_PORT` đúng.

---

## 11.4. Streamlit báo không kết nối được FastAPI

Phải chạy:

```powershell
python api.py
```

ở Terminal 1 trước.

Sau đó mới chạy:

```powershell
streamlit run stream_app.py
```

ở Terminal 2.

---

## 11.5. Dừng FastAPI hoặc Streamlit

Trong terminal đang chạy server:

```text
Ctrl + C
```

---

# 12. Quy trình làm việc nhóm

Đọc:

```text
docs/QUY-TRINH-LAM-VIEC.md
```

trước khi chỉnh sửa dự án.

Các nguyên tắc chính:

1. Chạy:

```powershell
git fetch origin
git pull
```

trước khi bắt đầu.

2. Kiểm tra branch:

```powershell
git branch --show-current
```

3. Không sửa, commit, push hoặc merge trực tiếp trên:

```text
main
```

4. Đặt tên branch theo quy ước:

```text
feature/<ten>
fix/<ten>
docs/<ten>
```

Ví dụ:

```text
feature/streamlit-dashboard
feature/fastapi
fix/model-loading
docs/update-readme
```

5. Thực hiện theo quy trình:

```text
Ý tưởng
   ↓
Chốt ý tưởng
   ↓
Kế hoạch
   ↓
Chốt kế hoạch
   ↓
Triển khai
```

6. Trước khi push, đồng bộ với `main` theo quy trình Git của nhóm.

7. Tạo Pull Request để review trước khi merge.

---

# 13. Tài liệu dự án

| Tài liệu | Nội dung |
|---|---|
| `README.md` | Hướng dẫn tổng quan và cài đặt dự án |
| `PROJECT_CONTEXT.md` | Trạng thái tổng thể và công việc tiếp theo |
| `AGENTS.md` | Quy định làm việc nhóm |
| `docs/QUY-TRINH-LAM-VIEC.md` | Quy trình Git và xử lý tình huống |
| `context/<ten>.md` | Ghi chú tiến độ cá nhân |
| `docs/Nhom-HomeCredit-tailieubaocao.docx` | Báo cáo đồ án |

---

# 14. Tóm tắt cách chạy nhanh

Sau khi đã cài đặt database, dữ liệu, model và dependency:

### Terminal 1

```powershell
cd credit-risk-classifier
.\.venv\Scripts\Activate.ps1
cd app
python api.py
```

### Terminal 2

```powershell
cd credit-risk-classifier
.\.venv\Scripts\Activate.ps1
cd app
streamlit run stream_app.py
```

Sau đó truy cập:

```text
Streamlit:
http://localhost:8501

FastAPI:
http://127.0.0.1:8000

Swagger API:
http://127.0.0.1:8000/docs
```

---

## Nhóm 01 — Dự án 1

**Đề tài:** Xây dựng Mô hình Phân loại và Dự báo Rủi ro Khách hàng Vay vốn

**FPT Polytechnic — HK Summer 2026**