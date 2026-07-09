# Context cá nhân — Huy

> Chỉ mình Huy sửa file này. Cập nhật cuối mỗi buổi làm việc rồi commit ngay trong nhánh task của bạn.
> Nhớ khai báo tên đầu phiên: `echo huy > .claude/whoami`

## Đang làm

- **Task:** T04 Notebook 02 - Pipeline PostgreSQL (kết nối, load)
- **Nhánh:** `feature/t04-postgres-pipeline`
- **Trạng thái:** Xong (Đã hoàn thành viết code, nạp database và kiểm chứng thành công)

## Làm tới đâu (cập nhật mới nhất ở trên)

- **2026-07-09:**
  - Khai báo định danh `huy` trong `.claude/whoami`.
  - Switch sang nhánh `feature/t04-postgres-pipeline` và rebase với `main` mới nhất.
  - Thêm các thư viện cần thiết (`psycopg2-binary`, `pandas`, `python-dotenv`, `sqlalchemy`) vào [requirements.txt](file:///d:/du%20an%201/requirements.txt) và cài đặt thành công.
  - Tạo file cấu hình [.env.example](file:///d:/du%20an%201/.env.example) và file `.env` local với mật khẩu chính xác là `h`.
  - Viết xong 3 script SQL còn thiếu: [03_views.sql](file:///d:/du%20an%201/sql/03_views.sql), [04_aggregation.sql](file:///d:/du%20an%201/sql/04_aggregation.sql), [05_indexes.sql](file:///d:/du%20an%201/sql/05_indexes.sql).
  - Hoàn thiện notebook [02_posgrespl_pipline.ipynb](file:///d:/du%20an%201/notebooks/02_posgrespl_pipline.ipynb) theo quy ước format của nhóm.
  - Thực thi thành công pipeline, nạp toàn bộ dữ liệu CSV thô từ `data/raw/` vào PostgreSQL database `credit-risk-classifier-DB` và kiểm chứng số dòng hoàn toàn khớp.

## Còn dở / việc tiếp theo của tôi

- [x] Sửa mật khẩu kết nối database trong file `.env` cho khớp với mật khẩu PostgreSQL local.
- [x] Chạy thực nghiệm toàn bộ Notebook 02 để xác thực dữ liệu được import đầy đủ và chính xác.
- [ ] Tạo PR và nhờ nhóm trưởng Hưng review & merge vào `main`.

## Ghi chú riêng

- Sử dụng `copy_expert` giúp chạy pipeline linh hoạt không phụ thuộc đường dẫn tuyệt đối của server PostgreSQL và tránh lỗi phân quyền Windows.

