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
5. **Báo cáo** (`reports/`): báo cáo Word + slide PowerPoint theo mẫu trường (`docs/2. Mau tai lieu.docx`, `docs/3. Mau bao cao.pptx`); theo dõi tiến độ nhóm bằng `Task_Tracker.xlsx`

## 3. Trạng thái hiện tại (cập nhật 2026-07-02)

- ✅ Đã dựng xong cấu trúc thư mục hoàn chỉnh
- ✅ Đã tải đầy đủ dữ liệu Home Credit vào `data/raw/`
- ✅ Có tài liệu môn học trong `docs/` (assignment, mẫu tài liệu, mẫu báo cáo)
- ❌ **Toàn bộ file code đều RỖNG** (chưa triển khai): tất cả notebooks, tất cả file SQL, tất cả file trong `app/`, `README.md`, `requirements.txt`, `models/*.pkl`
- Git: branch `main`, các commit gần nhất chỉ về cấu hình cấu trúc folder

## 4. Việc tiếp theo (chưa quyết định thứ tự, cần hỏi user)

Các hướng khởi đầu khả dĩ:
- Notebook `01_data_understanding.ipynb` (khám phá dữ liệu ban đầu)
- Script SQL tạo bảng + import dữ liệu vào PostgreSQL
- Viết `README.md` và `requirements.txt`

## 5. Ghi chú làm việc

- User trao đổi bằng **tiếng Việt** — trả lời bằng tiếng Việt
- Môi trường: Windows 11, PowerShell, repo git tại `D:\FPT Polytechnic\2026\HK Summer 2026\Block2\Du-an-01\credit-risk-classifier`
- Khi hoàn thành mốc quan trọng, cập nhật lại mục **3. Trạng thái hiện tại** và **4. Việc tiếp theo** trong file này
