# credit-risk-classifier

**Xây dựng Mô hình Phân loại và Dự báo Rủi ro Khách hàng Vay vốn**

Đồ án môn **Dự án 1** — FPT Polytechnic, Block 2, HK Summer 2026 — Nhóm 01.

---

## 1. Giới thiệu đề tài

Dự án xây dựng một pipeline AI dự đoán khả năng khách hàng vay gặp khó khăn trong việc trả nợ, sử dụng bộ dữ liệu **Home Credit Default Risk** trên Kaggle. Dữ liệu từ hồ sơ vay hiện tại và các bảng lịch sử được tổ chức trong PostgreSQL, tổng hợp về cấp khách hàng, làm sạch, tạo đặc trưng, huấn luyện mô hình và tối ưu ngưỡng phân loại.

| Nội dung | Mô tả |
|---|---|
| **Bài toán** | Phân loại nhị phân: `TARGET = 1` nếu khách hàng gặp khó khăn trong việc trả nợ, `TARGET = 0` nếu không |
| **Dữ liệu** | 8 bảng dữ liệu, khoảng 2,5 GB; bảng huấn luyện trung tâm có **307.511 dòng × 122 cột** |
| **Thách thức** | Quan hệ một-nhiều, dữ liệu thiếu, outlier, giá trị không hợp lệ và lớp nợ xấu chỉ chiếm khoảng **8,09%** |
| **Mô hình được chọn** | `HistGradientBoostingClassifier` |
| **Kết quả chính** | ROC-AUC **0,7780** ở bước so sánh mô hình; ngưỡng tối ưu F1 là **0,67** |
| **Công nghệ** | Python 3.11, PostgreSQL, pandas, scikit-learn, matplotlib, seaborn và Streamlit |

Do dữ liệu mất cân bằng, dự án không lựa chọn mô hình chỉ dựa trên Accuracy. Các chỉ số chính gồm ROC-AUC, PR-AUC, Precision, Recall và F1-score.

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
├── sql/                               # 11 script PostgreSQL, chạy theo thứ tự 01 → 11
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
├── app/                               # Khung ứng dụng Streamlit, chưa triển khai
├── data/
│   ├── raw/                           # CSV gốc từ Kaggle, không commit
│   ├── processed/                     # Dữ liệu trung gian cục bộ, không commit
│   └── sample/
├── models/                            # Artifact mô hình cục bộ, phần lớn không commit
├── reports/                           # Báo cáo, slide và hình ảnh
│   └── images/home_credit_erd.png
├── docs/                              # Tài liệu dự án và bản báo cáo đang cập nhật
├── context/                           # Ghi chú tiến độ riêng của từng thành viên
├── PROJECT_CONTEXT.md                 # Trạng thái tổng thể của dự án
├── AGENTS.md                          # Quy định làm việc nhóm
└── requirements.txt                   # Thư viện Python đã ghim phiên bản
```

> `data/`, `.env` và phần lớn artifact trong `models/` được `.gitignore`. Máy mới phải tải lại dữ liệu, cấu hình PostgreSQL và chạy pipeline để tái tạo các bảng cùng mô hình cần thiết.

---

## 3. Yêu cầu môi trường

| Thành phần | Phiên bản/điều kiện | Ghi chú |
|---|---|---|
| **Python** | 3.11 | Nhóm đang sử dụng Python 3.11.9 |
| **PostgreSQL** | 14+ | Bắt buộc từ NB02 đến NB06.1 |
| **RAM** | Tối thiểu 8 GB | Nên đóng các ứng dụng nặng khi chạy toàn bộ pipeline |
| **Ổ cứng** | Tối thiểu 7 GB trống | Dành cho dữ liệu thô, bảng PostgreSQL, môi trường và artifact cục bộ |

---

## 4. Cài đặt

### 4.1. Clone repo và tạo môi trường ảo

```bash
git clone https://github.com/thanhhung9720001-collab/credit-risk-classifier.git
cd credit-risk-classifier

python -m venv .venv
```

Kích hoạt môi trường trên Windows PowerShell:

```powershell
.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

`ipykernel` trong `requirements.txt` đủ để chạy notebook bằng VS Code. Nếu muốn chạy bằng trình duyệt, cài thêm JupyterLab:

```bash
pip install jupyterlab
jupyter lab
```

### 4.2. Tải dữ liệu Home Credit

Tải bộ [Home Credit Default Risk](https://www.kaggle.com/competitions/home-credit-default-risk/data), giải nén và đặt 9 file sau vào `data/raw/`:

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

### 4.3. Cấu hình PostgreSQL

Tạo file `.env` từ mẫu:

```powershell
Copy-Item .env.example .env
```

Cập nhật thông tin kết nối trong `.env`:

```ini
DB_HOST=localhost
DB_PORT=5432
DB_NAME=credit_risk_db
DB_USER=postgres
DB_PASSWORD=mat_khau_cua_ban
```

Tạo database rỗng trước khi chạy NB02:

```sql
CREATE DATABASE credit_risk_db;
```

Không commit file `.env` hoặc mật khẩu PostgreSQL lên Git.

---

## 5. Thứ tự chạy pipeline

Pipeline hiện tại sử dụng PostgreSQL làm nguồn dữ liệu trung tâm và cần chạy tuần tự:

```text
data/raw/*.csv
      │
      ├── NB00: Xác định bài toán và mục tiêu nghiên cứu
      ├── NB01: Khảo sát cấu trúc, chất lượng và quan hệ dữ liệu
      ▼
NB02: Tạo bảng, import, lập chỉ mục, tổng hợp và join
      │
      └── application_flat (307.511 × 180)
              ▼
NB03: Làm sạch dữ liệu
      │
      └── application_flat_cleaned (306.195 × 188)
              ▼
NB04: EDA và rút ra insight/đề xuất feature
              ▼
NB05: Feature Engineering
      │
      └── application_features (306.195 × 234)
              ▼
NB06: Tiền xử lý, huấn luyện và so sánh ba mô hình
      │
      └── Chọn HistGradientBoosting
              ▼
NB06.1: Chọn ngưỡng trên Validation và đánh giá Test một lần
      │
      └── Ngưỡng 0,67 + artifact mô hình cục bộ
              ▼
NB07 / Streamlit: Chưa triển khai
```

| Notebook | Đầu vào chính | Kết quả chính |
|---|---|---|
| **NB00** | Đề bài và bối cảnh nghiệp vụ | Bài toán, SWOT và mục tiêu nghiên cứu |
| **NB01** | 9 file trong `data/raw/` | Tổng quan dữ liệu, khóa liên kết và thách thức chất lượng |
| **NB02** | CSV gốc, PostgreSQL và `.env` | 8 bảng raw, bảng tổng hợp, chỉ mục và `application_flat` **307.511 × 180** |
| **NB03** | `application_flat` | `application_flat_cleaned` **306.195 × 188** |
| **NB04** | `application_flat_cleaned` | EDA theo nhóm biến, insight và đề xuất feature |
| **NB05** | `application_flat_cleaned` | 46 feature mới; `application_features` **306.195 × 234** |
| **NB06** | `application_features` | Dữ liệu sau preprocessing có 397 feature; so sánh Logistic Regression, Random Forest và HistGradientBoosting |
| **NB06.1** | `application_features` và cấu hình HGB | Chia Train/Validation/Test, preprocessing thành 360 feature, chọn ngưỡng 0,67 và lưu artifact cục bộ |

NB05 tạo 46 feature theo 7 nhóm. Trong đó, 44 feature được bàn giao trực tiếp; `age_income_interaction` và `late_debt_interaction` được tính lại từ tập Train trong NB06 để tránh data leakage.

---

## 6. Kết quả và trạng thái hiện tại

### 6.1. So sánh mô hình tại ngưỡng 0,5

| Mô hình | ROC-AUC | PR-AUC | Precision | Recall | F1-score |
|---|---:|---:|---:|---:|---:|
| Logistic Regression | 0,7714 | 0,2544 | 0,1741 | **0,6994** | 0,2788 |
| Random Forest | 0,7600 | 0,2424 | **0,1890** | 0,6163 | 0,2893 |
| **HistGradientBoosting** | **0,7780** | **0,2717** | 0,1840 | 0,6871 | **0,2903** |

HistGradientBoosting được chọn vì dẫn đầu đồng thời ROC-AUC, PR-AUC và F1-score trong lần đánh giá này.

### 6.2. Tối ưu ngưỡng

NB06.1 chia dữ liệu theo tỷ lệ xấp xỉ 64% Train, 16% Validation và 20% Test. Ngưỡng được lựa chọn trên Validation rồi mới đánh giá Test một lần.

| Chỉ số trên Test tại ngưỡng 0,67 | Kết quả |
|---|---:|
| Precision | 0,2630 |
| Recall | 0,4396 |
| F1-score | **0,3292** |
| True Negative | 50.183 |
| False Positive | 6.102 |
| False Negative | 2.776 |
| True Positive | 2.178 |

Ngưỡng 0,67 làm Precision và F1-score tăng so với ngưỡng 0,5, nhưng Recall giảm. Đây là sự đánh đổi cần trình bày rõ khi sử dụng mô hình trong nghiệp vụ.

### 6.3. Tiến độ sản phẩm

| Hạng mục | Trạng thái |
|---|---|
| SQL `01` → `11` | Hoàn thành |
| Notebook `00` → `06.1` | Hoàn thành nội dung và có kết quả chạy |
| Báo cáo Word | Đang cập nhật tại `docs/Nhom-HomeCredit-tailieubaocao.docx` |
| NB07 Prediction Demo | Chưa triển khai |
| Slide bảo vệ | Đã có file nền, cần cập nhật theo pipeline và kết quả mới |
| Streamlit/dashboard tương tác | Chưa triển khai; các file trong `app/` hiện còn rỗng |

---

## 7. Lưu ý kỹ thuật

### 7.1. `COPY` của PostgreSQL ghép dữ liệu theo vị trí cột

Tên cột giống nhau chưa đủ bảo đảm import đúng. Khi dùng `COPY`, phải kiểm tra số lượng và thứ tự cột giữa CSV với bảng PostgreSQL; nên khai báo danh sách cột rõ ràng và chạy các script kiểm tra sau import.

### 7.2. Tổng hợp bảng một-nhiều trước khi join

Các bảng lịch sử có nhiều dòng cho một khách hàng. Phải tổng hợp về grain `SK_ID_CURR` trước khi join để tránh nhân bản dòng. Riêng `bureau_balance` không có `SK_ID_CURR`, nên cần tổng hợp theo `SK_ID_BUREAU`, nối với `bureau`, rồi mới tổng hợp về khách hàng.

### 7.3. Không ép khai báo khóa ngoại khi dữ liệu nguồn có bản ghi mồ côi

Bộ dữ liệu Kaggle được tách theo mục đích thi nên một số quan hệ không bảo đảm toàn vẹn tham chiếu tuyệt đối. Pipeline sử dụng kiểm tra dữ liệu và chỉ mục để hỗ trợ join, thay vì cưỡng ép khóa ngoại làm import thất bại.

### 7.4. Không điền toàn bộ giá trị thiếu theo một quy tắc

Một số `NaN` mang ý nghĩa khách hàng không có loại lịch sử tương ứng. Cần đọc cùng các cờ lịch sử, chỉ điền giá trị khi có căn cứ nghiệp vụ và tránh biến trạng thái “không có dữ liệu” thành số 0 sai nghĩa.

### 7.5. Ngăn data leakage

Mọi median, danh mục encoding, ngưỡng phân vị và tham số tạo feature phụ thuộc dữ liệu phải được học từ tập Train. Hai feature tương tác `age_income_interaction` và `late_debt_interaction` được tạo lại trong NB06 vì lý do này.

### 7.6. Restart Kernel và Run All trước khi bàn giao notebook

Không dựa vào biến còn sót trong kernel. Trước khi commit, cần chạy notebook từ đầu, kiểm tra `execution_count`, output lỗi và bảo đảm nhận xét khớp với kết quả thực tế. Không dùng `warnings.filterwarnings("ignore")` toàn cục vì có thể che lỗi quan trọng.

### 7.7. Ứng dụng phải dùng ngưỡng 0,67

NB07 và Streamlit phải lấy xác suất bằng `predict_proba()` rồi phân loại theo ngưỡng 0,67. Không dùng `.predict()` với ngưỡng mặc định 0,5 nếu muốn tái hiện kết quả đã tối ưu trong NB06.1.

### 7.8. Artifact mô hình không đi theo Git

Các artifact tối ưu của NB06.1 được tạo cục bộ trong `models/` và phần lớn bị `.gitignore`. Máy triển khai phải chạy lại NB06.1 hoặc nhận đúng bộ artifact, danh sách feature, preprocessing và ngưỡng tương ứng.

---

## 8. Quy trình làm việc nhóm

Đọc [`docs/QUY-TRINH-LAM-VIEC.md`](docs/QUY-TRINH-LAM-VIEC.md) trước khi chỉnh sửa dự án.

Các nguyên tắc chính:

1. Chạy `git fetch origin` và `git pull` trước khi bắt đầu.
2. Kiểm tra nhánh bằng `git branch --show-current`; không sửa, commit, push hoặc merge trực tiếp trên `main`.
3. Đặt tên nhánh theo quy ước `feature/<tên>`, `fix/<tên>` hoặc `docs/<tên>`.
4. Thực hiện đúng quy trình **Ý tưởng → Chốt ý tưởng → Kế hoạch → Chốt kế hoạch → Triển khai**.
5. Trước khi push, chạy `git pull --rebase origin main`, sau đó tạo Pull Request để nhóm review.

| Tài liệu | Nội dung |
|---|---|
| [`PROJECT_CONTEXT.md`](PROJECT_CONTEXT.md) | Trạng thái tổng thể và việc tiếp theo của dự án |
| [`AGENTS.md`](AGENTS.md) | Nguồn quy định làm việc nhóm duy nhất |
| [`docs/QUY-TRINH-LAM-VIEC.md`](docs/QUY-TRINH-LAM-VIEC.md) | Quy trình Git và xử lý tình huống chi tiết |
| `context/<tên>.md` | Ghi chú tiến độ cá nhân của từng thành viên |
