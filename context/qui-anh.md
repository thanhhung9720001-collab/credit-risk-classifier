# Context cá nhân — Qui Anh

> Chỉ mình Qui Anh sửa file này. Cập nhật cuối mỗi buổi làm việc rồi commit ngay trong nhánh task của bạn.
> Nhớ khai báo tên đầu phiên: `echo qui-anh > .claude/whoami`

## Đang làm

- **Task:** T03 SQL 02 - Import dữ liệu vào PostgreSQL
- **Nhánh:** `feature/t03-sql-import-data`
- **Trạng thái:** Đã test import OK trên pgAdmin — chờ review & merge PR

## Làm tới đâu (cập nhật mới nhất ở trên)

- **2026-07-04:**
  - Khai báo định danh `qui-anh` trong `.claude/whoami`.
  - Tạo và chuyển sang nhánh làm việc `feature/t03-sql-import-data`.
  - Giải nén bộ dữ liệu `home-credit-default-risk.zip` từ thư mục `Downloads` vào thư mục dự án [data/raw/](file:///c:/Users/quian/OneDrive/Desktop/credit-risk-classifier/data/raw/).
  - Thiết kế và hoàn thiện mã script SQL [02_import_data.sql](file:///c:/Users/quian/OneDrive/Desktop/credit-risk-classifier/sql/02_import_data.sql) hỗ trợ import dữ liệu (cả bằng psql client-side `\copy` và pgAdmin server-side `COPY`).
  - Viết tài liệu hướng dẫn chạy thử nghiệm và kiểm tra tại [walkthrough.md](file:///c:/Users/quian/.gemini/antigravity-ide/brain/29437933-23cb-45cc-9097-147643e86c58/walkthrough.md).
  - Phát hiện lỗi chặn: schema `01_create_tables.sql` khai 25 cột kiểu `INT` nhưng dữ liệu Home Credit lưu số thực (`-3648.0`, `12.0`...) → `COPY` fail `invalid input syntax for type integer`.
  - Sửa 25 cột đó sang `DOUBLE PRECISION` trong `01_create_tables.sql` (LƯU Ý: file này thuộc task T02 của Thắng — đã báo/nhờ Thắng & Hưng review trong PR).
  - Chạy lại `01` (tạo bảng) → `02` (import) trên pgAdmin với database `credit-risk-classifier-DB`: **thành công, không lỗi**.

## Còn dở / việc tiếp theo của tôi

- [x] Chạy thử import trên DB cục bộ (`credit-risk-classifier-DB`) — OK, không lỗi.
- [ ] Push nhánh `feature/t03-sql-import-data` lên GitHub và tạo Pull Request (PR).
- [ ] Báo Thắng biết PR có chỉnh schema `01_create_tables.sql` (task T02 của Thắng); nhờ nhóm trưởng Hưng review & merge vào `main`.

## Ghi chú riêng

- PostgreSQL Port 5432 trên máy đang ở trạng thái active (đang lắng nghe). Khi chạy lệnh import bằng dòng lệnh, cần đảm bảo điền đúng mật khẩu tài khoản `postgres`.
