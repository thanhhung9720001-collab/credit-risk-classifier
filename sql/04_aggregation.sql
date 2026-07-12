-- ============================================================================
-- DỰ ÁN 1: XÂY DỰNG MÔ HÌNH PHÂN LOẠI VÀ DỰ BÁO RỦI RO KHÁCH HÀNG VAY VỐN
-- Script 04: Feature Engineering & Aggregation
-- Mô tả:
--   Tạo các bảng đặc trưng tổng hợp từ các bảng dữ liệu phụ
--   theo khóa SK_ID_CURR để phục vụ mô hình Machine Learning.
-- Tác giả: Đỗ Trọng Thái
-- Ngày tạo: 2026-07-12
---------------------------------------------------------------
-- 1. Bureau Features
---------------------------------------------------------------
CREATE TABLE bureau_features AS
SELECT
    SK_ID_CURR,
    COUNT(*) AS bureau_loan_count,
    SUM(AMT_CREDIT_SUM) AS bureau_credit_sum,
    AVG(AMT_CREDIT_SUM) AS bureau_credit_avg,
    MAX(DAYS_CREDIT) AS bureau_recent_credit,
    AVG(CREDIT_DAY_OVERDUE) AS bureau_avg_overdue
FROM bureau
GROUP BY SK_ID_CURR;


---------------------------------------------------------------
-- 2. Previous Application Features
---------------------------------------------------------------
CREATE TABLE previous_features AS
SELECT
    SK_ID_CURR,
    COUNT(*) AS previous_count,
    AVG(AMT_APPLICATION) AS avg_application,
    AVG(AMT_CREDIT) AS avg_credit,
    SUM(AMT_CREDIT) AS total_credit,
    AVG(RATE_DOWN_PAYMENT) AS avg_down_payment
FROM previous_application
GROUP BY SK_ID_CURR;


---------------------------------------------------------------
-- 3. Bureau Balance Features
---------------------------------------------------------------

-- Aggregate theo SK_ID_BUREAU
CREATE TABLE bureau_balance_temp AS
SELECT
    SK_ID_BUREAU,
    COUNT(*) AS month_count,
    SUM(CASE WHEN STATUS='0' THEN 1 ELSE 0 END) AS status0_count,
    SUM(CASE WHEN STATUS='1' THEN 1 ELSE 0 END) AS status1_count
FROM bureau_balance
GROUP BY SK_ID_BUREAU;

-- Aggregate lên SK_ID_CURR
CREATE TABLE bureau_balance_features AS
SELECT
    b.SK_ID_CURR,
    AVG(bb.month_count) AS avg_month_count,
    SUM(bb.status0_count) AS total_status0,
    SUM(bb.status1_count) AS total_status1
FROM bureau b
JOIN bureau_balance_temp bb
ON b.SK_ID_BUREAU = bb.SK_ID_BUREAU
GROUP BY b.SK_ID_CURR;


---------------------------------------------------------------
-- 4. POS CASH Features
---------------------------------------------------------------
CREATE TABLE pos_features AS
SELECT
    SK_ID_CURR,
    COUNT(*) AS pos_count,
    AVG(CNT_INSTALMENT) AS avg_instalment,
    AVG(SK_DPD) AS avg_dpd,
    MAX(SK_DPD) AS max_dpd
FROM POS_CASH_balance
GROUP BY SK_ID_CURR;


---------------------------------------------------------------
-- 5. Installment Features
---------------------------------------------------------------
CREATE TABLE installment_features AS
SELECT
    SK_ID_CURR,
    COUNT(*) AS payment_count,
    AVG(AMT_PAYMENT) AS avg_payment,
    SUM(AMT_PAYMENT) AS total_payment,
    AVG(DAYS_ENTRY_PAYMENT - DAYS_INSTALMENT) AS avg_delay
FROM installments_payments
GROUP BY SK_ID_CURR;


---------------------------------------------------------------
-- 6. Credit Card Features
---------------------------------------------------------------
CREATE TABLE credit_card_features AS
SELECT
    SK_ID_CURR,
    COUNT(*) AS card_count,
    AVG(AMT_BALANCE) AS avg_balance,
    MAX(AMT_BALANCE) AS max_balance,
    AVG(AMT_CREDIT_LIMIT_ACTUAL) AS avg_limit
FROM credit_card_balance
GROUP BY SK_ID_CURR;
