# credit-risk-classifier

**Xây dựng Mô hình Phân loại và Dự báo Rủi ro Khách hàng Vay vốn**

Đồ án môn **Dự án 1** — FPT Polytechnic, Block 2, HK Summer 2026 — Nhóm 01.

---

## 1. Giới thiệu đề tài

Xây dựng mô hình machine learning dự đoán khả năng **vỡ nợ (default)** của khách hàng vay vốn, dựa trên bộ dữ liệu **Home Credit Default Risk** (Kaggle).

| | |
|---|---|
| **Bài toán** | Phân loại nhị phân (`TARGET` = 1 nếu khách hàng gặp khó khăn trả nợ) |
| **Dữ liệu** | 8 bảng, ~2,5 GB — bảng trung tâm `application_train` có **307.511 dòng × 122 cột** |
| **Thách thức chính** | `TARGET` **mất cân bằng nặng (~8%)** → đánh giá bằng **AUC-ROC**, KHÔNG dùng accuracy (đoán bừa "không vỡ nợ" đã đạt ~92% accuracy nhưng mô hình vô dụng) |
| **Công nghệ** | Python 3.11, PostgreSQL, pandas, scikit-learn, Streamlit |

---

## 2. Cấu trúc thư mục

```
credit-risk-classifier/
├── notebooks/           # Pipeline chính (xem thứ tự chạy ở mục 5)
│   ├── 01_data_understanding.ipynb      ✅ Tìm hiểu dữ liệu
│   ├── 02_posgrespl_pipline.ipynb       ✅ Pipeline PostgreSQL
│   ├── 03_data_cleaning.ipynb           ✅ Làm sạch dữ liệu
│   ├── 04_eda_visualization.ipynb       ✅ EDA & trực quan hóa
│   ├── 05_feature_engineering.ipynb     ✅ Feature engineering
│   ├── 06_machine_learnig.ipynb         ❌ Huấn luyện mô hình (CHƯA LÀM)
│   └── 07_prediction_demo.ipynb         ❌ Demo dự đoán (CHƯA LÀM)
├── sql/                 # ✅ Script PostgreSQL, chạy theo thứ tự 01 → 05
│   ├── 01_create_tables.sql             Tạo 8 bảng
│   ├── 02_import_data.sql               Import CSV bằng lệnh COPY
│   ├── 03_views.sql                     7 view làm sạch + chỉ số nghiệp vụ
│   ├── 04_aggregation.sql               3 materialized view tổng hợp
│   └── 05_indexes.sql                   Index khóa ngoại + composite/partial
├── app/                 # ❌ Demo Streamlit (các file còn RỖNG)
├── data/
│   ├── raw/             # CSV tải từ Kaggle — KHÔNG commit (xem mục 4.3)
│   ├── processed/       # Dữ liệu đã xử lý — KHÔNG commit (notebook tự sinh)
│   └── sample/
├── models/              # model.pkl + scaler.pkl — KHÔNG commit
├── context/             # Ghi chú tiến độ cá nhân từng thành viên
├── docs/                # Tài liệu môn học + quy trình làm việc nhóm
├── reports/             # Báo cáo Word + slide PowerPoint
├── PROJECT_CONTEXT.md   # Bức tranh tổng dự án (nhóm trưởng làm chủ)
├── AGENTS.md            # Quy định làm việc nhóm (nguồn sự thật duy nhất)
└── requirements.txt     # Thư viện Python (đã ghim phiên bản)
```

> ⚠️ **`data/`, `models/` và `.env` đều được `.gitignore`** — chúng KHÔNG đi theo git. Máy mới clone về phải tự tải dữ liệu và tự chạy notebook để sinh lại. Xem mục 4.

---

## 3. Yêu cầu môi trường

| Thành phần | Bản dùng | Ghi chú |
|---|---|---|
| **Python** | **3.11** | Cả nhóm dùng 3.11.9. Bản khác dễ lệch phiên bản thư viện. |
| **PostgreSQL** | 14+ | **Chỉ cần nếu chạy NB02/NB04** — xem mục 5. |
| **RAM** | 8 GB+ | Cần ~4 GB trống cho NB03/NB05. Máy yếu xem mục 7. |
| **Ổ cứng** | ~7 GB trống | 2,5 GB dữ liệu thô + ~2,2 GB dữ liệu sinh ra + thư viện. |

---

## 4. Cài đặt

### 4.1. Clone repo và tạo môi trường ảo

```bash
git clone https://github.com/thanhhung9720001-collab/credit-risk-classifier.git
cd credit-risk-classifier

python -m venv .venv

# Windows (PowerShell)
.venv\Scripts\Activate.ps1
# macOS / Linux
source .venv/bin/activate

pip install -r requirements.txt
```

> Mặc định chỉ cài `ipykernel` — đủ để chạy notebook **trong VS Code**. Muốn mở bằng trình duyệt thì cài thêm: `pip install jupyterlab` rồi chạy `jupyter lab`.

### 4.2. Tải dữ liệu từ Kaggle

Tải bộ [Home Credit Default Risk](https://www.kaggle.com/competitions/home-credit-default-risk/data) và giải nén **toàn bộ 9 file CSV** vào `data/raw/`:

```
data/raw/
├── application_train.csv          ├── previous_application.csv
├── application_test.csv           ├── installments_payments.csv
├── bureau.csv                     ├── credit_card_balance.csv
├── bureau_balance.csv             ├── POS_CASH_balance.csv
└── HomeCredit_columns_description.csv
```

> NB01 có sẵn bước tự kiểm tra và sẽ báo `FileNotFoundError` kèm tên file còn thiếu nếu đặt sai chỗ.

### 4.3. Tạo file `.env` — *chỉ cần nếu dùng PostgreSQL*

```bash
copy .env.example .env      # macOS/Linux: cp .env.example .env
```

Sửa `.env` cho khớp máy mình:

```ini
DB_HOST=localhost
DB_PORT=5432
DB_NAME=credit_risk_db
DB_USER=postgres
DB_PASSWORD=mat_khau_cua_ban
```

### 4.4. Tạo database rỗng — *chỉ cần nếu dùng PostgreSQL*

```sql
CREATE DATABASE credit_risk_db;
```

Không cần tạo bảng bằng tay — NB02 sẽ tự chạy toàn bộ script trong `sql/`.

---

## 5. Thứ tự chạy pipeline

Pipeline **không phải một đường thẳng 01→07**. Thực tế có **2 nhánh độc lập**:

```
 NHÁNH CSV (KHÔNG cần PostgreSQL)         NHÁNH DATABASE (cần PostgreSQL)
 ────────────────────────────────         ───────────────────────────────
 data/raw/*.csv                           data/raw/*.csv
      │                                        │
      ├──► NB01  Tìm hiểu dữ liệu              ├──► NB02  Tạo bảng + import + view
      │                                        │         │
      ├──► NB03  Làm sạch                      └──► NB04 │ EDA & trực quan hóa
      │      │                                           │
      │      └─► data/processed/*_clean.csv    (NB04 cần NB02 chạy trước)
      │              │
      └──► NB05  Feature engineering
             │
             └─► data/processed/train_features.csv
                 models/scaler.pkl
                     │
                 NB06  Huấn luyện mô hình  ──►  models/model.pkl
                     │
                 NB07 + app/  Demo dự đoán
```

**Hệ quả thực tế:** nếu bạn chỉ muốn **huấn luyện mô hình** (NB06), bạn **không cần cài PostgreSQL** — chỉ cần chạy NB03 → NB05. PostgreSQL chỉ phục vụ NB02/NB04 (phần nghiệp vụ SQL và EDA của môn học).

| Notebook | Cần gì trước | Sinh ra gì |
|---|---|---|
| **NB01** | `data/raw/` | *(chỉ đọc & phân tích)* |
| **NB02** | `data/raw/` + PostgreSQL + `.env` | 8 bảng + view + index trong DB |
| **NB03** | `data/raw/` | `application_train_clean.csv` (307.511 dòng)<br>`application_test_clean.csv` (48.744 dòng) |
| **NB04** | **Đã chạy NB02** + `.env` | *(biểu đồ EDA)* |
| **NB05** | **Đã chạy NB03** + `data/raw/` | `train_features.csv` (307.511×299, ~1,87 GB)<br>`test_features.csv` (48.744×298)<br>`models/scaler.pkl` |
| **NB06** | **Đã chạy NB05** | `models/model.pkl` |
| **NB07** | **Đã chạy NB06** | *(demo dự đoán)* |

> 💡 **Chỉ cần ĐỌC kết quả thì KHÔNG phải chạy lại gì cả.** Notebook 01–05 đã được chạy sẵn trên toàn bộ dữ liệu và kết quả lưu ngay trong file — cứ mở lên đọc. Chỉ chạy lại khi bạn sửa code, hoặc cần sinh `train_features.csv` trên máy mình để làm NB06.

---

## 6. Trạng thái hiện tại

| Hạng mục | Trạng thái |
|---|---|
| SQL `01` → `05` | ✅ Hoàn thành |
| Notebook `01` → `05` | ✅ Hoàn thành, đã chạy trên **toàn bộ** dữ liệu |
| `data/processed/train_features.csv` | ✅ Sẵn sàng cho NB06 (307.511 × 299) |
| `models/scaler.pkl` | ✅ Đã fit trên dữ liệu đầy đủ |
| Notebook `06` (huấn luyện ML) | ❌ **Chưa làm — ưu tiên số 1** |
| Notebook `07` + `app/` (Streamlit) | ❌ Chưa làm (file còn rỗng) |
| `models/model.pkl` | ❌ Hiện là **file rỗng 0 byte** (placeholder — chưa train mô hình nào) |

---

## 7. Những cái bẫy đã biết (đọc trước khi chạy)

Nhóm đã mất nhiều thời gian vì các lỗi dưới đây. Đọc kỹ để khỏi vấp lại.

### 🚩 Cờ `DEBUG` của NB03 và NB05 phải KHỚP nhau

Cả hai notebook có cờ `DEBUG` ở ô cấu hình đầu:

- `DEBUG = False` (**mặc định hiện tại**) → chạy toàn bộ dữ liệu, ra kết quả chính thức.
- `DEBUG = True` → chỉ lấy mẫu 15.000 train / 5.000 test, chạy nhanh cho máy yếu RAM.

**NB05 đọc lại file mà NB03 xuất ra.** Nếu NB03 chạy `DEBUG = True` thì `application_train_clean.csv` chỉ có 15.000 dòng → dù NB05 để `DEBUG = False` cũng **không thể** có đủ dữ liệu. Muốn bộ đầy đủ: chạy **NB03 với `DEBUG = False` trước**, rồi mới tới NB05.

### 🚩 Máy yếu RAM

Bước tốn RAM nhất là NB05 gom các bảng phụ (`bureau_balance` 27 triệu dòng, `installments_payments` 13,6 triệu dòng) — hàm `read_by_chunks` khi `DEBUG = False` **nạp nguyên file, không lọc**. Đỉnh RAM đo được thực tế **~3,3 GB**. Máy không đủ thì đặt `DEBUG = True` để chạy thử, và nhờ người có máy khỏe chạy bản đầy đủ.

### 🚩 KHÔNG dùng `warnings.filterwarnings("ignore")` toàn cục

Chính dòng này đã nuốt mất `ChainedAssignmentError` của pandas 3, khiến một bước làm sạch ở NB03 **thất bại âm thầm suốt thời gian dài mà không ai biết**. Chỉ tắt riêng loại cảnh báo ồn ào:

```python
warnings.filterwarnings("ignore", category=FutureWarning)
warnings.filterwarnings("ignore", category=DeprecationWarning)
warnings.filterwarnings("ignore", category=pd.errors.PerformanceWarning)
```

### 🚩 Restart & Run All trước khi commit notebook

NB05 từng có ô cấu hình **chưa hề chạy** (`execution_count = None`) trong khi các ô sau chạy bằng giá trị cũ còn sót trong kernel → code ghi `DEBUG = False` nhưng output nhúng lại là dữ liệu mẫu. Kiểm tra nhanh: **`execution_count` phải liền mạch 1, 2, 3...**

### 🚩 Đừng gỡ dấu ghim phiên bản trong `requirements.txt`

Nhóm đã dính lỗi "chạy được máy tác giả, hỏng máy khác" nhiều lần do lệch phiên bản (pandas 3.0 đổi cách đọc cột chữ → NB05 lỗi `UFuncTypeError`; pandas 3.0 bật Copy-on-Write → NB03 sai âm thầm). Muốn đổi phiên bản thì bàn với cả nhóm.

### 🚩 Chạy lại NB02 nhiều lần vẫn an toàn

NB02 có `TRUNCATE TABLE` trước khi `COPY` nên **idempotent** — chạy lại không bị nạp trùng dữ liệu.

---

## 8. Quy trình làm việc nhóm

**Bắt buộc đọc trước khi code:** [`docs/QUY-TRINH-LAM-VIEC.md`](docs/QUY-TRINH-LAM-VIEC.md) — quy trình chi tiết + xử lý tình huống.

4 quy tắc vàng:

1. **Luôn `git pull`** trước khi bắt đầu làm việc.
2. **KHÔNG bao giờ code/commit/push trực tiếp trên `main`** — có hook và GitHub Ruleset chặn tự động.
3. **Đặt tên nhánh** theo quy ước: `feature/<tên>`, `fix/<tên>`, `docs/<tên>`. Task có mã thì đưa mã vào đầu: `feature/t19-<tên>`.
4. **Push nhánh và tạo Pull Request** — chỉ nhóm trưởng (Hưng) được merge vào `main`.

Tài liệu liên quan:

| File | Nội dung |
|---|---|
| [`PROJECT_CONTEXT.md`](PROJECT_CONTEXT.md) | Bức tranh tổng dự án, trạng thái, việc tiếp theo (nhóm trưởng làm chủ) |
| [`AGENTS.md`](AGENTS.md) | Quy định nhóm — nguồn sự thật duy nhất |
| [`docs/QUY-TRINH-LAM-VIEC.md`](docs/QUY-TRINH-LAM-VIEC.md) | Quy trình git chi tiết từng bước |
| `context/<tên>.md` | Ghi chú tiến độ cá nhân (chỉ chủ nhân sửa) |
