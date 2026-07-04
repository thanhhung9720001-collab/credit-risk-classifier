-- ============================================================================
-- DỰ ÁN 1: XÂY DỰNG MÔ HÌNH PHÂN LOẠI VÀ DỰ BÁO RỦI RO KHÁCH HÀNG VAY VỐN
-- Script 02: Import dữ liệu từ CSV vào PostgreSQL (pgAdmin / DBeaver Friendly)
-- Tác giả: Đặng Trịnh Qui Anh (qui-anh)
-- Ngày tạo: 2026-07-04
-- ============================================================================
--
-- !!! LƯU Ý QUAN TRỌNG — MỖI MÁY PHẢI TỰ ĐỔI ĐƯỜNG DẪN TRƯỚC KHI CHẠY !!!
--
-- Các lệnh COPY bên dưới đọc file CSV theo đường dẫn TUYỆT ĐỐI trên máy chạy
-- PostgreSQL. Đường dẫn mặc định 'C:/Users/Public/credit-risk-data/...' là của
-- máy tác giả — máy bạn để CSV ở chỗ khác thì phải sửa lại cho khớp.
--
-- CÁCH ĐỔI:
--   1. Chép toàn bộ file .csv (trong data/raw của repo) tới 1 thư mục mà tài khoản
--      chạy PostgreSQL đọc được. Khuyên dùng C:/Users/Public/credit-risk-data
--      (thư mục Public ai cũng đọc được -> tránh lỗi phân quyền Windows trên pgAdmin).
--   2. Nếu bạn để ở đường dẫn khác: dùng Find & Replace (Ctrl+H) trong pgAdmin/DBeaver,
--      thay TẤT CẢ 'C:/Users/Public/credit-risk-data' bằng đường dẫn thư mục của bạn.
--   3. Đường dẫn dùng dấu gạch chéo xuôi '/' (VD: 'D:/data/credit-risk-data/...'),
--      KHÔNG dùng dấu '\' của Windows.
-- ============================================================================

-- Bắt đầu giao dịch (Transaction)
BEGIN;

-- 1. Xóa dữ liệu cũ nếu đã tồn tại trước khi import mới
TRUNCATE TABLE application_train CASCADE;
TRUNCATE TABLE application_test CASCADE;
TRUNCATE TABLE bureau CASCADE;
TRUNCATE TABLE bureau_balance CASCADE;
TRUNCATE TABLE previous_application CASCADE;
TRUNCATE TABLE pos_cash_balance CASCADE;
TRUNCATE TABLE installments_payments CASCADE;
TRUNCATE TABLE credit_card_balance CASCADE;

-- 2. Import dữ liệu. (NHỚ đổi đường dẫn 'C:/Users/Public/credit-risk-data' bên dưới
--    cho khớp máy bạn — xem hướng dẫn ở đầu file. Dùng Ctrl+H để thay hàng loạt.)
COPY application_train 
FROM 'C:/Users/Public/credit-risk-data/application_train.csv' 
WITH (FORMAT CSV, HEADER, DELIMITER ',');

COPY application_test 
FROM 'C:/Users/Public/credit-risk-data/application_test.csv' 
WITH (FORMAT CSV, HEADER, DELIMITER ',');

COPY bureau 
FROM 'C:/Users/Public/credit-risk-data/bureau.csv' 
WITH (FORMAT CSV, HEADER, DELIMITER ',');

COPY bureau_balance 
FROM 'C:/Users/Public/credit-risk-data/bureau_balance.csv' 
WITH (FORMAT CSV, HEADER, DELIMITER ',');

COPY previous_application 
FROM 'C:/Users/Public/credit-risk-data/previous_application.csv' 
WITH (FORMAT CSV, HEADER, DELIMITER ',');

COPY pos_cash_balance 
FROM 'C:/Users/Public/credit-risk-data/POS_CASH_balance.csv' 
WITH (FORMAT CSV, HEADER, DELIMITER ',');

COPY installments_payments 
FROM 'C:/Users/Public/credit-risk-data/installments_payments.csv' 
WITH (FORMAT CSV, HEADER, DELIMITER ',');

COPY credit_card_balance 
FROM 'C:/Users/Public/credit-risk-data/credit_card_balance.csv' 
WITH (FORMAT CSV, HEADER, DELIMITER ',');

COMMIT;
