-- ============================================================================
-- DỰ ÁN 1: XÂY DỰNG MÔ HÌNH PHÂN LOẠI VÀ DỰ BÁO RỦI RO KHÁCH HÀNG VAY VỐN
-- Script 04: Tạo các bảng/view tổng hợp nâng cao (Advanced Aggregations)
-- Tác giả: Nguyễn Bá Gia Huy (huy)
-- Ngày tạo: 2026-07-09
-- ============================================================================

-- Dọn dẹp các materialized view cũ nếu đã tồn tại để tránh xung đột
DROP MATERIALIZED VIEW IF EXISTS agg_installments_summary CASCADE;
DROP MATERIALIZED VIEW IF EXISTS agg_pos_cash_summary CASCADE;
DROP MATERIALIZED VIEW IF EXISTS agg_credit_card_summary CASCADE;

-- 1. MATERIALIZED VIEW agg_installments_summary: Tổng hợp lịch sử trả góp (installments_payments) theo từng khách hàng
CREATE MATERIALIZED VIEW agg_installments_summary AS
SELECT 
    sk_id_curr,
    COUNT(sk_id_prev) AS total_installment_records,
    -- Tính toán số lần trễ hạn (ngày thực trả > ngày phải trả)
    SUM(CASE WHEN days_entry_payment > days_instalment THEN 1 ELSE 0 END) AS cnt_late_payments,
    -- Tính toán số lần trả thiếu (số tiền thực trả < số tiền phải trả)
    SUM(CASE WHEN amt_payment < amt_instalment THEN 1 ELSE 0 END) AS cnt_under_payments,
    -- Tổng số tiền phải trả và đã trả
    COALESCE(SUM(amt_instalment), 0) AS total_amt_installment_required,
    COALESCE(SUM(amt_payment), 0) AS total_amt_installment_paid,
    -- Số ngày trễ hạn trung bình và tối đa
    COALESCE(AVG(CASE WHEN days_entry_payment > days_instalment THEN days_entry_payment - days_instalment ELSE 0 END), 0) AS avg_days_late,
    COALESCE(MAX(CASE WHEN days_entry_payment > days_instalment THEN days_entry_payment - days_instalment ELSE 0 END), 0) AS max_days_late
FROM installments_payments
GROUP BY sk_id_curr;

-- Đánh index cho materialized view này để tăng tốc truy vấn JOIN sau này
CREATE UNIQUE INDEX idx_agg_installments_curr ON agg_installments_summary (sk_id_curr);


-- 2. MATERIALIZED VIEW agg_pos_cash_summary: Tổng hợp lịch sử tài khoản POS/CASH (pos_cash_balance)
CREATE MATERIALIZED VIEW agg_pos_cash_summary AS
SELECT 
    sk_id_curr,
    COUNT(sk_id_prev) AS total_pos_cash_records,
    COALESCE(AVG(cnt_instalment), 0) AS avg_pos_cash_installments,
    COALESCE(AVG(cnt_instalment_future), 0) AS avg_pos_cash_future_installments,
    COALESCE(MAX(sk_dpd), 0) AS max_pos_cash_dpd,
    SUM(CASE WHEN sk_dpd > 0 THEN 1 ELSE 0 END) AS cnt_pos_cash_dpd_months
FROM pos_cash_balance
GROUP BY sk_id_curr;

CREATE UNIQUE INDEX idx_agg_pos_cash_curr ON agg_pos_cash_summary (sk_id_curr);


-- 3. MATERIALIZED VIEW agg_credit_card_summary: Tổng hợp lịch sử tài khoản thẻ tín dụng (credit_card_balance)
CREATE MATERIALIZED VIEW agg_credit_card_summary AS
SELECT 
    sk_id_curr,
    COUNT(sk_id_prev) AS total_credit_card_records,
    COALESCE(AVG(amt_balance), 0) AS avg_card_balance,
    COALESCE(MAX(amt_balance), 0) AS max_card_balance,
    COALESCE(AVG(amt_credit_limit_actual), 0) AS avg_card_limit,
    COALESCE(AVG(amt_drawings_current), 0) AS avg_card_drawings,
    COALESCE(MAX(sk_dpd), 0) AS max_card_dpd,
    SUM(CASE WHEN sk_dpd > 0 THEN 1 ELSE 0 END) AS cnt_card_dpd_months
FROM credit_card_balance
GROUP BY sk_id_curr;

CREATE UNIQUE INDEX idx_agg_credit_card_curr ON agg_credit_card_summary (sk_id_curr);
