# Context cá nhân — Thắng

> Chỉ mình Thắng sửa file này. Cập nhật cuối mỗi buổi làm việc rồi commit ngay trong nhánh task của bạn.
> Nhớ khai báo tên đầu phiên: `echo thang > .claude/whoami`

## Đang làm

- **Task:** T07 SQL 05 - Tạo indexes tối ưu truy vấn
- **Nhánh:** `feature/t07-sql-indexes`
- **Trạng thái:** Đang thực hiện

## Làm tới đâu (cập nhật mới nhất ở trên)

- **2026-07-13:** Nhận task T07, tạo nhánh `feature/t07-sql-indexes` từ `main` mới nhất. Rà soát file `sql/05_indexes.sql` hiện có và lập kế hoạch tối ưu chỉ mục cho các bảng.
- **2026-07-03:** Hoàn thành thiết kế schema PostgreSQL cho 8 bảng dữ liệu thô. Viết mã script SQL đầy đủ và tối ưu kiểu dữ liệu tại [01_create_tables.sql](file:///d:/FPT%20Polytechnic%202026/HK%20Summer%202026/Block2/Du-an-01/credit-risk-classifier/sql/01_create_tables.sql). Rà soát kỹ lưỡng cú pháp và định dạng. Sẵn sàng tạo Pull Request.
- **2026-07-03:** Khai báo danh tính `thang`, pull code mới nhất trên main và switch sang nhánh `feature/t02-sql-create-tables`. Bắt đầu nghiên cứu cấu trúc dữ liệu và lập kế hoạch tạo bảng SQL.

## Còn dở / việc tiếp theo của tôi

- [ ] Nghiên cứu các câu lệnh SELECT/JOIN trong `sql/03_views.sql` và `sql/04_aggregation.sql` để tìm các trường cần lập index bổ sung.
- [ ] Hoàn thiện file [05_indexes.sql](file:///c:/Users/bivibi/Downloads/credit-risk-classifier-main/sql/05_indexes.sql) và cập nhật thông tin tác giả.
- [ ] Chạy thử nghiệm tạo index trên cơ sở dữ liệu local để kiểm tra cú pháp và tính đúng đắn.
- [ ] Tạo Pull Request gửi nhóm trưởng review chéo.

## Ghi chú riêng

- Xem cấu trúc bảng trong tài liệu `01_data_understanding.ipynb` hoặc mô tả cột trong Kaggle dataset.
