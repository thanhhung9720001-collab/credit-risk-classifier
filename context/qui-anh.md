# Context cá nhân — Qui Anh

> Chỉ mình Qui Anh sửa file này. Cập nhật cuối mỗi buổi làm việc rồi commit ngay trong nhánh task của bạn.
> Nhớ khai báo tên đầu phiên: `echo qui-anh > .claude/whoami`

## Đang làm

- **Task:** T36 Notebook 05 - Feature Engineering (làm lại sau đợt reset PR #52; mã cũ T10 đã vô hiệu)
- **Nhánh:** `feature/t36-feature-engineering`
- **Trạng thái:** Notebook đã hoàn thành và chạy `Restart & Run All` sạch. Chờ review và merge PR.

## Làm tới đâu (cập nhật mới nhất ở trên)

- **2026-07-31:**
  - Đọc lại toàn bộ quy trình trước khi làm: `PROJECT_CONTEXT.md`, `AGENTS.md`, `docs/QUY-TRINH-LAM-VIEC.md`, bộ `docs/huong-dan-giang-vien/` và checklist NB05 trong `Task Checklist for Each Notebook.docx`.
  - Tạo nhánh `feature/t36-feature-engineering` từ `main` mới nhất. **Không dùng lại nhánh `feature/t10-feature-engineering`** vì nhánh đó trên GitHub vẫn giữ bản NB05 cũ từ trước đợt reset PR #52, pull về sẽ kéo lại file đã bỏ.
  - **Dựng lại database trên máy mình** vì đang ở trạng thái cũ (`bureau_summary` chỉ 7 cột, `application_flat` 148 cột, chưa có `application_flat_cleaned`): chạy `sql/06_create_summary_tables.sql` (171 giây) rồi `sql/08_create_application_flat.sql`, ra `application_flat` đúng chuẩn 307.511 x 154.
  - Chạy lại toàn bộ Notebook 03 để sinh `application_flat_cleaned`: ra **305.181 dòng x 127 cột**, khớp tuyệt đối với output Huy đã commit. Pipeline tái lập được trên máy khác.
  - **Hoàn thành `notebooks/05_feature_engineering.ipynb`**: 65 cell (17 code, 48 markdown), 8 mục lớn theo đúng checklist của thầy (I Giới thiệu đến VIII Tổng kết). `Restart & Run All` sạch, `execution_count` liền mạch 1 đến 17, không cell nào lỗi, 2 biểu đồ nhúng thật.
    - Xây dựng **18 đặc trưng phái sinh**, đánh giá bằng tương quan Pearson và Permutation Importance, **giữ 15 và loại 3** (`credit_to_income`, `has_cc_dpd`, `young_and_cc_dpd`).
    - Kết quả: AUC-ROC tăng từ 0,7768 (chỉ cột gốc) lên **0,7798** khi thêm đặc trưng mới. `ext_sources_mean` là đặc trưng quan trọng nhất trong toàn bộ 270 cột, gấp hơn 9 lần đặc trưng thứ hai; 5 trong 10 đặc trưng quan trọng nhất là do notebook này tạo ra.
    - Lưu bảng `application_features` (305.181 x 269) vào PostgreSQL bằng lệnh `COPY`, đã kiểm chứng giá trị thiếu vào database thành `NULL` đúng chuẩn.

- **2026-07-04:**
  - Khai báo định danh `qui-anh` trong `.claude/whoami`.
  - Tạo và chuyển sang nhánh làm việc `feature/t03-sql-import-data`.
  - Giải nén bộ dữ liệu `home-credit-default-risk.zip` từ thư mục `Downloads` vào `data/raw/`.
  - Thiết kế và hoàn thiện script SQL `02_import_data.sql` (hỗ trợ cả `\copy` của psql lẫn `COPY` server-side của pgAdmin).
  - Phát hiện lỗi chặn: schema `01_create_tables.sql` khai 25 cột kiểu `INT` nhưng dữ liệu Home Credit lưu số thực → `COPY` fail. Đã sửa 25 cột đó sang `DOUBLE PRECISION`.
  - Chạy lại `01` rồi `02` trên pgAdmin: thành công, không lỗi.

## Còn dở / việc tiếp theo của tôi

- [x] Viết đủ các cell code mục II, IV, V, VI, VII.
- [x] Viết mục VIII.1 "Kết quả Feature Engineering" bằng con số thật sau khi chạy.
- [x] Chạy `Restart & Run All` một lượt sạch, `execution_count` liền mạch 1 đến 17.
- [ ] Push nhánh và tạo PR, nhờ Hưng review & merge.
- [ ] **Báo Huy và Hưng** hai lỗi trong NB03 và hai nhận xét sai trong NB04 ghi ở mục Ghi chú riêng bên dưới. Con số 22% của NB04 rất dễ bị đưa thẳng vào whitepaper và slide nên cần báo sớm.
- [ ] Nhắc người làm NB06: đọc bảng `application_features`, dữ liệu **chưa chuẩn hóa** nên nếu dùng Logistic Regression thì phải `fit` scaler sau khi chia train/test; đánh giá bằng AUC-ROC chứ không dùng accuracy.

## Ghi chú riêng

- PostgreSQL port 5432 trên máy đang active. File `.env` nằm ở **gốc repo**, không có trong `notebooks/`. NB03 và NB04 dùng `load_dotenv(".env")` là đường dẫn tương đối nên nếu chạy từ thư mục `notebooks/` sẽ không tìm thấy — NB05 mình dùng `load_dotenv(find_dotenv())` để chạy được ở cả hai chỗ.

- **Hai lỗi phát hiện trong NB03 (2026-07-31) — cần báo Huy và Hưng:**
  1. **Markdown NB03 nhắc tới các cột `has_bureau`, `has_previous`, `has_installments`, `has_pos_cash`, `has_credit_card` nhưng code chưa bao giờ tạo chúng.** Bảng `application_flat_cleaned` không có cột nào tên `has_*`. Lại đúng kiểu lỗi "markdown nói một đằng, dữ liệu một nẻo".
  2. **NB03 ghi giá trị thiếu vào PostgreSQL dưới dạng `NaN` chứ không phải `NULL`.** PostgreSQL kiểu `DOUBLE PRECISION` coi `NaN` là giá trị hợp lệ, khác `NULL`, và xếp `NaN` lớn hơn mọi số khác. Hệ quả: đọc bằng pandas thì đúng (`credit_card_count` thiếu 218.465 ô, `bureau_count` thiếu 43.706 ô), nhưng truy vấn SQL thuần `IS NULL` trả về 0, và `MAX(credit_card_count)` trả về `NaN`. Kiểm chứng cụ thể: số khách mới mở tín dụng dưới 1 năm tính bằng pandas là 150.352, tính bằng SQL thuần ra 194.058 — chênh đúng 43.706 khách không có lịch sử bureau. **NB05 không bị ảnh hưởng vì đọc bằng pandas, nhưng NB06, NB07 và app Streamlit sẽ dính bẫy nếu truy vấn bằng SQL thuần.**

- **Hai nhận xét sai trong NB04 (2026-07-31) — cần báo Huy và Hưng gấp vì dễ bị đưa thẳng vào whitepaper và slide:**
  - NB04 viết *"khách từng quá hạn thẻ tín dụng có tỷ lệ nợ xấu tăng vọt gần 15%"*. Chạy lại **đúng đoạn code của NB04** trên cùng bảng `application_flat_cleaned`: thực tế chỉ **8,22%** so với 8,09% của nhóm không trễ hạn — chênh 0,13 điểm phần trăm, gần như không phân tách được gì.
  - NB04 viết *"khách trẻ dưới 35 mà trễ hạn thẻ chịu tỷ lệ vỡ nợ gần 22%, cao gấp 3 lần bình thường"*. Thực tế là **12,32%** (2.703 khách). Quan trọng hơn: nhóm dưới 35 tuổi **không** trễ hạn thẻ đã có tỷ lệ 10,90%, nghĩa là rủi ro chủ yếu đến từ **tuổi trẻ** chứ không phải từ việc trễ hạn thẻ.
  - Nhận xét của NB04 về **trả góp** thì đúng: có trễ hạn trả góp 9,43% so với không trễ hạn 6,74%.
  - Số liệu đối chiếu đầy đủ đã ghi trong nhận xét mục IV.4 của Notebook 05.
