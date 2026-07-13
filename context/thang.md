# Context cá nhân — Thắng

> Chỉ mình Thắng sửa file này. Cập nhật cuối mỗi buổi làm việc rồi commit ngay trong nhánh task của bạn.
> Nhớ khai báo tên đầu phiên: `echo thang > .claude/whoami`

## Đang làm

- **Task:** T10 Notebook 05 - Feature Engineering
- **Nhánh:** `feature/t10-feature-engineering`
- **Trạng thái:** Hoàn thành (Đang gửi PR)

## Làm tới đâu (cập nhật mới nhất ở trên)

- **2026-07-13:** Hoàn thành xây dựng notebook `05_feature_engineering.ipynb` theo đúng Quy ước định dạng notebook của nhóm. Triển khai kỹ thuật đọc dữ liệu theo chunk để tránh lỗi tràn RAM (OOM) do bộ dữ liệu Home Credit quá lớn (~2.5GB). Đã tổng hợp thành công các đặc trưng nghiệp vụ từ 5 bảng phụ:
  - `bureau` & `bureau_balance` (số lượng khoản vay ngoài, số khoản vay active, tổng dư nợ nợ ngoài, tỷ lệ nợ nợ/hạn mức trung bình, v.v.)
  - `previous_application` (tỷ lệ duyệt hồ sơ cũ, tỷ lệ số tiền duyệt/đăng ký trung bình, v.v.)
  - `installments_payments` (tần suất trễ hạn, đóng thiếu, số ngày trễ tối đa, v.v.)
  - `POS_CASH_balance` (số ngày quá hạn tối đa POS, số tháng quá hạn POS, v.v.)
  - `credit_card_balance` (tỷ lệ sử dụng thẻ trung bình, dư nợ thẻ trung bình, v.v.)
  Đồng thời thiết lập các biến tương tác tài chính nghiệp vụ (DTI, Payment rate...), mã hóa One-Hot, chuẩn hóa StandardScaler và xuất dữ liệu sạch ra `data/processed/train_features.csv` và `data/processed/test_features.csv`, lưu đối tượng chuẩn hóa vào `models/scaler.pkl`. Đã chạy toàn bộ notebook ở chế độ DEBUG mẫu (20,000 dòng) thành công và lưu output thật vào notebook.
- **2026-07-03:** Hoàn thành thiết kế schema PostgreSQL cho 8 bảng dữ liệu thô. Viết mã script SQL đầy đủ và tối ưu kiểu dữ liệu tại [01_create_tables.sql](file:///d:/FPT%20Polytechnic%202026/HK%20Summer%202026/Block2/Du-an-01/credit-risk-classifier/sql/01_create_tables.sql). Rà soát kỹ lưỡng cú pháp và định dạng. Sẵn sàng tạo Pull Request.
- **2026-07-03:** Khai báo danh tính `thang`, pull code mới nhất trên main và switch sang nhánh `feature/t02-sql-create-tables`. Bắt đầu nghiên cứu cấu trúc dữ liệu và lập kế hoạch tạo bảng SQL.

## Còn dở / việc tiếp theo của tôi

- [x] Xây dựng notebook 05: đọc dữ liệu từ `data/raw/`, làm sạch tối thiểu, tổng hợp đặc trưng từ bảng phụ (bureau, previous_application, installments_payments, credit_card_balance, POS_CASH_balance), tạo biến mới, mã hóa/scale.
- [x] Xuất bảng đặc trưng hoàn chỉnh ra `data/processed/`.
- [x] Chạy toàn bộ notebook để nhúng output thật, sau đó `git pull --rebase origin main` rồi push + tạo PR.
- [ ] Chờ nhóm trưởng review và merge PR nhánh `feature/t10-feature-engineering`.

## Ghi chú riêng

- Xem cấu trúc bảng trong tài liệu `01_data_understanding.ipynb` hoặc mô tả cột trong Kaggle dataset.
