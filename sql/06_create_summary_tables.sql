-- 06_create_summary_tables.sql
-- Muc dich: gom moi bang phu ve dung 1 dong cho moi khach hang truoc khi join.
-- Giai thich chi tiet tung khoi: xem Muc 5.2 trong notebook 02.

-- 1. bureau
DROP TABLE IF EXISTS bureau_summary CASCADE;

CREATE TABLE bureau_summary AS
SELECT
    sk_id_curr,
    COUNT(*)                 AS bureau_count,
    SUM(amt_credit_sum)      AS bureau_sum_credit,
    SUM(amt_credit_sum_debt) AS bureau_sum_debt,
    MAX(credit_day_overdue)  AS bureau_max_overdue,
    AVG(days_credit)         AS bureau_avg_days_credit,
    MAX(days_credit)         AS bureau_latest_days_credit
FROM bureau
GROUP BY sk_id_curr;

CREATE UNIQUE INDEX idx_bureau_summary_curr ON bureau_summary (sk_id_curr);

-- 2. previous_application
DROP TABLE IF EXISTS previous_summary CASCADE;

CREATE TABLE previous_summary AS
SELECT
    sk_id_curr,
    COUNT(*)           AS previous_count,
    SUM(amt_credit)    AS previous_sum_credit,
    AVG(amt_credit)    AS previous_avg_credit,
    AVG(days_decision) AS previous_avg_days_decision,
    MAX(days_decision) AS previous_latest_decision
FROM previous_application
GROUP BY sk_id_curr;

CREATE UNIQUE INDEX idx_previous_summary_curr ON previous_summary (sk_id_curr);

-- 3. installments_payments
DROP TABLE IF EXISTS installments_summary CASCADE;

CREATE TABLE installments_summary AS
SELECT
    sk_id_curr,
    COUNT(*)                                  AS installments_count,
    SUM(amt_instalment)                       AS installments_sum_due,
    SUM(amt_payment)                          AS installments_sum_paid,
    AVG(days_entry_payment - days_instalment) AS installments_avg_late,
    MAX(days_entry_payment - days_instalment) AS installments_max_late
FROM installments_payments
GROUP BY sk_id_curr;

CREATE UNIQUE INDEX idx_installments_summary_curr ON installments_summary (sk_id_curr);

-- 4. pos_cash_balance
DROP TABLE IF EXISTS pos_cash_summary CASCADE;

CREATE TABLE pos_cash_summary AS
SELECT
    sk_id_curr,
    COUNT(*)            AS pos_cash_count,
    AVG(sk_dpd)         AS pos_cash_avg_dpd,
    MAX(sk_dpd)         AS pos_cash_max_dpd,
    MIN(months_balance) AS pos_cash_oldest_month,
    MAX(months_balance) AS pos_cash_latest_month
FROM pos_cash_balance
GROUP BY sk_id_curr;

CREATE UNIQUE INDEX idx_pos_cash_summary_curr ON pos_cash_summary (sk_id_curr);

-- 5. credit_card_balance
DROP TABLE IF EXISTS credit_card_summary CASCADE;

CREATE TABLE credit_card_summary AS
SELECT
    sk_id_curr,
    COUNT(*)                     AS credit_card_count,
    AVG(amt_balance)             AS credit_card_avg_balance,
    MAX(amt_balance)             AS credit_card_max_balance,
    AVG(amt_credit_limit_actual) AS credit_card_avg_limit,
    MAX(sk_dpd)                  AS credit_card_max_dpd
FROM credit_card_balance
GROUP BY sk_id_curr;

CREATE UNIQUE INDEX idx_credit_card_summary_curr ON credit_card_summary (sk_id_curr);
