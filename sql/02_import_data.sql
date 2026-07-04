-- ============================================================================
-- DỰ ÁN 1: XÂY DỰNG MÔ HÌNH PHÂN LOẠI VÀ DỰ BÁO RỦI RO KHÁCH HÀNG VAY VỐN
-- Script 02: Import dữ liệu từ CSV vào PostgreSQL (pgAdmin / DBeaver Friendly)
-- Tác giả: Đặng Trịnh Qui Anh (qui-anh)
-- Ngày tạo: 2026-07-04
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

-- 2. Import dữ liệu từ thư mục Public (để tránh lỗi phân quyền Windows trên pgAdmin)
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
