# PROJECT CONTEXT — Prompt khôi phục ngữ cảnh

> **Cách dùng:** Khi bắt đầu phiên làm việc mới với Claude Code, gõ:
> `Đọc file PROJECT_CONTEXT.md để nắm ngữ cảnh dự án, sau đó tiếp tục làm việc với tôi.`

---

## 1. Tổng quan dự án

- **Tên đề tài (VI):** Xây dựng Mô hình Phân loại và Dự báo Rủi ro Khách hàng Vay vốn
- **Tên đề tài (EN):** credit-risk-classifier
- **Bối cảnh:** Đồ án môn **Dự án 1**, FPT Polytechnic, Block 2 — HK Summer 2026, làm theo nhóm (nhóm 01)
- **Mục tiêu:** Xây dựng mô hình machine learning phân loại rủi ro tín dụng — dự đoán khách hàng vay có khả năng vỡ nợ (default) hay không
- **Dữ liệu:** Bộ **Home Credit Default Risk** (Kaggle), ~2.5GB tại `data/raw/`:
  - `application_train.csv` / `application_test.csv` — đơn vay chính (bảng trung tâm, có cột target)
  - `bureau.csv`, `bureau_balance.csv` — lịch sử tín dụng từ tổ chức khác
  - `previous_application.csv` — các khoản vay trước đó tại Home Credit
  - `installments_payments.csv` — lịch sử trả góp
  - `credit_card_balance.csv`, `POS_CASH_balance.csv` — số dư thẻ tín dụng / POS
  - `HomeCredit_columns_description.csv` — mô tả các cột

## 2. Kiến trúc & quy trình dự kiến (end-to-end)

1. **Notebooks** (`notebooks/`, thứ tự 01→07):
   - `01_data_understanding.ipynb` — tìm hiểu dữ liệu
   - `02_posgrespl_pipline.ipynb` — pipeline PostgreSQL
   - `03_data_cleaning.ipynb` — làm sạch dữ liệu
   - `04_eda_visualization.ipynb` — EDA & trực quan hóa
   - `05_feature_engineering.ipynb` — feature engineering
   - `06_machine_learnig.ipynb` — huấn luyện mô hình ML
   - `07_prediction_demo.ipynb` — demo dự đoán
2. **SQL** (`sql/`, dùng PostgreSQL): `01_create_tables.sql` → `02_import_data.sql` → `03_views.sql` → `04_aggregation.sql` → `05_indexes.sql`
3. **App** (`app/`): demo bằng **Streamlit** (`stream_app.py`, `pages/`, `prediction.py`) + có thể thêm API (`api.py`)
4. **Models** (`models/`): lưu `model.pkl` và `scaler.pkl` sau khi train
5. **Báo cáo** (`reports/`): báo cáo Word + slide PowerPoint theo mẫu trường (`docs/2. Mau tai lieu.docx`, `docs/3. Mau bao cao.pptx`); theo dõi tiến độ nhóm bằng **Google Sheet** (nhóm trưởng quản lý, link ở nhóm chat — không nằm trong repo)

## 3. Trạng thái hiện tại (cập nhật 2026-07-13)

- ✅ Đã dựng xong cấu trúc thư mục hoàn chỉnh
- ✅ Đã tải đầy đủ dữ liệu Home Credit vào `data/raw/`
- ✅ Có tài liệu môn học trong `docs/` (assignment, mẫu tài liệu, mẫu báo cáo)
- ✅ Đã chốt **quy ước định dạng notebook** (xem mục 6) và tạo cell tiêu đề chuẩn cho cả 7 notebook
- ✅ Đã thiết lập **quy trình làm việc nhóm qua git** — gồm nhiều lớp:
  - **GitHub Ruleset**: `protect-main` (cấm push thẳng, bắt buộc PR, chặn force-push/xóa nhánh) + `chi-co-nhom-truong-duoc-merge` (chỉ nhóm trưởng merge được vào main)
  - **Hook Claude Code** (`.claude/settings.json` + `.claude/hooks/`): (1) đầu phiên tự fetch, nhắc pull, **chào theo tên + nhắc file context**; (2) chặn commit/push/merge trên main; (3) **chặn cả thao tác sửa file trên main** (`edit-branch-guard.sh`) — kể cả khi tự đổi về main mà Claude chưa biết
  - **Tài liệu**: `docs/QUY-TRINH-LAM-VIEC.md` (quy trình chi tiết + Phần 0 quyền đổi cấu trúc + Phần 6 context cá nhân) + `CLAUDE.md` (quy tắc cho Claude)
- ✅ **Nội quy (2026-07-03)**: chỉ **nhóm trưởng (Hưng)** được thay đổi cấu trúc thư mục / quy trình / quy định (Phần 0 quy trình)
- ✅ **Context cá nhân (2026-07-03)**: mỗi thành viên có 1 file `context/<tên>.md` (chỉ chủ nhân sửa → hết conflict); khai báo tên đầu phiên qua `.claude/whoami` (không commit). `PROJECT_CONTEXT.md` từ nay do **nhóm trưởng làm chủ** (bức tranh tổng)
- 🔄 **Triển khai nội dung code** (cập nhật 2026-07-13):
  - ✅ **Toàn bộ 5 script SQL — HOÀN THÀNH**: `01_create_tables.sql` (T02, PR #15 — schema 8 bảng, tối ưu kiểu số); `02_import_data.sql` (T03, PR #16/#17 — import CSV bằng `COPY`, ghi chú đổi đường dẫn từng máy); `03_views.sql` (T05, PR #19 — 7 view làm sạch + chỉ số nghiệp vụ CIC/dư nợ/trễ hạn/dùng thẻ); `04_aggregation.sql` (kèm pipeline T04, PR #23 — 3 materialized view tổng hợp installments/pos_cash/credit_card theo khách hàng, có unique index); `05_indexes.sql` (T07, PR #25 — index khóa ngoại + composite/partial cho bureau_balance & target).
  - ✅ **Notebook 01 (`01_data_understanding.ipynb`) — HOÀN THÀNH** (T01, PR #12): 32 cell; tổng quan 8 bảng, phân tích `application_train` (307.511×122, `TARGET` ~8%, 67 cột thiếu), quan hệ khóa, từ điển dữ liệu.
  - ✅ **Notebook 02 (`02_posgrespl_pipline.ipynb`) — HOÀN THÀNH** (T04, PR #23): pipeline PostgreSQL bằng Python (tạo bảng → import `copy_expert` → view/aggregation/index → validation). **Đã sửa** lỗi env path (`find_dotenv`) và lỗi nạp trùng dữ liệu (thêm `TRUNCATE` cho idempotent) — fix PR #27.
  - ✅ **Notebook 04 (`04_eda_visualization.ipynb`) — HOÀN THÀNH** (T09, PR #24): EDA đơn/đa biến, tương quan, biểu đồ theo `TARGET`. **Đã sửa** đồng bộ env path + bổ sung biểu đồ mục 4 (bureau) + nhận xét — fix PR #28.
  - ✅ **Notebook 05 (`05_feature_engineering.ipynb`) — HOÀN THÀNH** (T10, PR #26/#29): tổng hợp đặc trưng từ 5 bảng phụ, biến nghiệp vụ (DTI, ext_source...), One-Hot, StandardScaler (fit trên train, tránh leakage), xuất `data/processed/*.csv` + `models/scaler.pkl`. **Đã vá** `reduce_mem_usage` để chạy được trên pandas 3.0/numpy 2.x. Lưu ý: cờ `DEBUG=True` mặc định chỉ xuất dữ liệu MẪU (15k/5k) — đổi `DEBUG=False` để tạo bộ đầy đủ.
  - ✅ **`requirements.txt`** — đã có đủ thư viện: `psycopg2-binary, pandas, numpy, python-dotenv, sqlalchemy, matplotlib, seaborn, scikit-learn, joblib`.
  - ❌ **Còn lại (chưa làm):** notebook `03_data_cleaning`, `06_machine_learnig`, `07_prediction_demo` mới có cell tiêu đề; các file trong `app/` (Streamlit) còn rỗng; `README.md` rỗng; `models/model.pkl` chưa có (mới có `scaler.pkl` do NB05 sinh, đã gitignore).
  - ⚠️ **Bài học chung (2026-07-13):** NB02/04/05 đều dính lỗi kiểu *"chạy được máy tác giả, hỏng máy khác"* — đường dẫn cứng, thiếu thư viện trong `requirements.txt`, và **lệch phiên bản** (pandas 3.0/numpy 2.x vs bản cũ). Nên **ghim phiên bản thư viện** trong `requirements.txt` để cả nhóm chạy giống nhau.

## 4. Việc tiếp theo (chưa quyết định thứ tự, cần hỏi user)

**Với mọi thành viên trước khi bắt đầu:** đọc `docs/QUY-TRINH-LAM-VIEC.md` và làm theo checklist đầu phiên (pull code mới → **khai báo tên** `echo <tên> > .claude/whoami` + tạo `context/<tên>.md` → tạo/chuyển nhánh, KHÔNG code trên main). Ai đã kéo quy trình mới về nhớ **khởi động lại Claude Code** để nạp hook.

Các hướng tiếp theo khả dĩ (mỗi việc = 1 nhánh riêng, đưa mã task vào đầu tên nhánh nếu có — vd `feature/t0x-...`; xem gợi ý phân công 5 người trong quy trình):
- **Notebook `03_data_cleaning.ipynb`** (làm sạch dữ liệu) — hiện mới có cell tiêu đề. Lưu ý: NB05 đã tự làm sạch tối thiểu vì NB03 chưa có; cần chốt lại vai trò của NB03 trong pipeline.
- **Notebook `06_machine_learnig.ipynb`** (huấn luyện & so sánh mô hình ML) — đọc `data/processed/*.csv` từ NB05, train, đánh giá, lưu `models/model.pkl`. **Nhắc:** trước khi train thật phải chạy NB05 với `DEBUG=False` để có bộ đặc trưng đầy đủ (mặc định đang xuất dữ liệu mẫu).
- **Notebook `07_prediction_demo.ipynb`** + **`app/` (Streamlit)** — demo dự đoán, nạp `model.pkl` + `scaler.pkl`.
- **`README.md`** (hiện rỗng) — hướng dẫn cài đặt & chạy dự án.
- **Ghim phiên bản thư viện trong `requirements.txt`** (vd cố định `pandas`, `numpy`, `scikit-learn`) để cả nhóm chạy đồng nhất, tránh lỗi lệch phiên bản như đã gặp ở NB05.

> ✅ Đã xong: Notebook 01 (T01, PR #12), 02 (T04, PR #23 + fix #27), 04 (T09, PR #24 + fix #28), 05 (T10, PR #26/#29); toàn bộ SQL 01–05 (T02/T03/T05/T04/T07); `requirements.txt` cơ bản.

## 5. Ghi chú làm việc

- User trao đổi bằng **tiếng Việt** — trả lời bằng tiếng Việt
- Môi trường: Windows 11, PowerShell, repo git tại `D:\FPT Polytechnic\2026\HK Summer 2026\Block2\Du-an-01\credit-risk-classifier`
- File này (`PROJECT_CONTEXT.md`) = bức tranh tổng, **do nhóm trưởng cập nhật** (thường khi merge PR). Thành viên **đọc**, không sửa — tiến độ cá nhân ghi vào `context/<tên>.md` của mình.
- Khi hoàn thành mốc quan trọng, nhóm trưởng cập nhật lại mục **3. Trạng thái hiện tại** và **4. Việc tiếp theo** trong file này

## 6. Quy ước định dạng notebook (chốt 2026-07-02)

Áp dụng thống nhất cho cả 7 notebook — **mọi phiên làm việc phải tuân theo**:

1. **Cell đầu tiên (Markdown):** tiêu đề dự án (H1 `#`) → dòng `**Notebook XX/07 — Tên EN (Tên tiếng Việt)**` → gạch ngang `---` → các trường: **🎯 Mục tiêu**, **📥 Input**, **📤 Output**, **🔗 Pipeline** (notebook trước → **hiện tại** → notebook sau). Cả 7 notebook đã có sẵn cell này làm mẫu.
2. **Đề mục thân notebook:** mục lớn `## 1.`, `## 2.`, ...; mục con `### 1.1.`, `### 1.2.`, ...; cấp 3 `#### 1.1.1.`, ...; cấp 4 KHÔNG dùng heading mà dùng chữ đậm `**a. ...**`, `**b. ...**`. H1 (`#`) chỉ dành riêng cho tiêu đề notebook ở cell đầu.
3. **Nhận xét sau kết quả:** cell code có output mang ý nghĩa phân tích (bảng thống kê, biểu đồ, kết quả đánh giá mô hình...) phải có cell Markdown ngay bên dưới, mở đầu bằng `**Nhận xét:**`. Cell kỹ thuật thuần túy (import, config, định nghĩa hàm) không bắt buộc nhận xét — chỉ cần một dòng Markdown dẫn dắt phía trên nhóm cell đó.
4. **Cuối notebook:** mục **Tổng kết** (mang số thứ tự cuối cùng, ví dụ `## 6. Tổng kết`) chốt các phát hiện chính và nêu bước tiếp theo (dẫn sang notebook kế tiếp).
