# Context cá nhân — Qui Anh

> Chỉ mình Qui Anh sửa file này. Cập nhật cuối mỗi buổi làm việc rồi commit ngay trong nhánh task của bạn.
> Nhớ khai báo tên đầu phiên: `echo qui-anh > .claude/whoami`

## Đang làm

- **Task:** T04 — Dựng lại Notebook 02 (Database Pipeline trung tâm)
- **Nhánh:** `feature/t04-rebuild-postgres-pipeline`
- **Trạng thái:** Đã dựng xong notebook, đã kiểm chứng code trên DB thật — **chờ Restart & Run All rồi mới merge**

## Làm tới đâu (cập nhật mới nhất ở trên)

- **2026-07-19:**
  - Xóa toàn bộ `02_posgrespl_pipline.ipynb` để dựng lại từ đầu theo feedback giảng viên ngày 2026-07-18.
  - Dựng lại notebook: **63 cell (13 code / 50 markdown), 9 mục lớn**, Tổng kết đứng cuối.
  - Áp 3 quy ước trình bày: **không icon**; **mỗi cell code nằm dưới một tiêu đề `###` riêng**; **sau mỗi output có cell markdown `**Nhận xét:**`**. Giải thích kỹ thuật viết thành comment ngắn trong code.
  - Notebook đóng vai trò bản diễn giải: hàm `execute_sql_file()` gọi thẳng `sql/01`, `03`, `04`, `05` — logic SQL vẫn nằm nguyên trong thư mục `sql/`, không chép lại vào notebook.
  - **Nối mạch với NB01:** mục 1.1 nhận 2 trong 4 thách thức NB01 nêu ở mục 8.1 (phân mảnh quan hệ 1-n, quy mô lớn), giao 2 thách thức còn lại cho NB03/NB06; mục 9.2 đối chiếu ngược lại.
  - **Thêm mục 5.2** — cell join `application_train` với 3 bảng `agg_*` bằng `LEFT JOIN`, kèm `assert` số dòng trước/sau join bằng nhau. Đây là kịch bản unit test đề bài yêu cầu ở Chương 2 whitepaper.
  - Thay `COPY FROM 'đường/dẫn'` (server-side) bằng `COPY FROM STDIN` (client-side) — hết lỗi phân quyền Windows từng gặp khi chạy `sql/02_import_data.sql` trên pgAdmin, và chạy được bằng đường dẫn tương đối.
  - Bỏ đường dẫn cứng `'../data/raw/...'` của bản cũ; thay bằng dò `REPO_ROOT` nên chạy được dù kernel mở từ `notebooks/` hay từ gốc repo.
  - **Đã kiểm chứng trên DB thật** (`credit-risk-classifier-DB`, PostgreSQL 18.4): join giữ đúng 307.511 dòng trước và sau (không nhân dòng), 8 bảng raw khớp số dòng NB01, 10 view/materialized view tồn tại đủ, cả 3 câu `assert` đều qua.

## Còn dở / việc tiếp theo của tôi

- [ ] **Restart & Run All NB02** để nhúng output thật (hiện 13 cell code đều `execution_count = null`, chưa có output). Kiểm tra `execution_count` liền mạch 1→13 trước khi merge.
- [ ] Sau khi chạy xong thì commit thêm và báo Hưng review PR.

## Việc cần báo nhóm (không thuộc task của tôi)

- **NB03 cell 43** đã có sẵn code ghi bảng clean về PostgreSQL nhưng **chưa bao giờ chạy** (`execution_count = None`, 0 output) → bảng `application_train_clean` / `application_test_clean` hiện **chưa có trong database**.
- **NB05 chưa có code ghi ngược** `train_features` / `test_features` về database, dù sơ đồ pipeline ở NB01 mục 8.2 ghi là có.
- Vì vậy mục 6 (hợp đồng dữ liệu) của NB02 ghi rõ 4 bảng đó do NB03/NB05 tạo, kèm đoạn `assert` kiểm tra tồn tại trước khi đọc.

## Ghi chú riêng

- Phạm vi NB02 đã chốt lại: **chỉ raw + view/join/aggregation/index + validation**. Việc ghi ngược clean/features thuộc NB03 và NB05, theo đúng sơ đồ pipeline ở NB01 mục 8.2 — không gộp vào NB02 để tránh trùng việc và đụng notebook người khác.
- NB02 nay **chỉ cần `data/raw/`**, không phụ thuộc `data/processed/` → chạy được ngay sau NB01, không phải chờ NB03/NB05.
- `data/processed/` trên máy tôi vẫn là dữ liệu mẫu 15.000/5.000 dòng (chạy `DEBUG = True` từ trước). Không ảnh hưởng NB02, nhưng khi nào đụng tới NB05 phải chạy lại NB03 với `DEBUG = False` trước.
- PostgreSQL port 5432 trên máy đang active. Tên database trong `.env` của tôi là `credit-risk-classifier-DB` (khác mặc định `credit_risk_db` trong `.env.example`).
