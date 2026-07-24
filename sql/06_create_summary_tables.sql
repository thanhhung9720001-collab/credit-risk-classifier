-- 06_create_summary_tables.sql
-- Muc dich: gom moi bang phu ve dung 1 dong cho moi khach hang truoc khi join.
-- Giai thich chi tiet tung khoi: xem Muc 5.2 trong notebook 02.

-- 1. bureau_balance: gom lich su theo khoan vay truoc khi noi vao bureau.
-- STATUS '0' khong qua han; '1' den '5' la cac muc qua han; 'C' da dong; 'X' chua co trang thai.
DROP TABLE IF EXISTS bureau_balance_summary CASCADE;

CREATE TABLE bureau_balance_summary AS
SELECT
    sk_id_bureau,
    COUNT(*) AS bureau_balance_month_count,
    COUNT(*) FILTER (WHERE status IN ('1', '2', '3', '4', '5')) AS bureau_balance_dpd_month_count,
    MAX(CASE WHEN status IN ('1', '2', '3', '4', '5') THEN status::SMALLINT END) AS bureau_balance_max_dpd_status,
    COUNT(*) FILTER (WHERE status = 'C') AS bureau_balance_closed_month_count,
    COUNT(*) FILTER (WHERE status = 'X') AS bureau_balance_unknown_month_count
FROM bureau_balance
GROUP BY sk_id_bureau;

CREATE UNIQUE INDEX idx_bureau_balance_summary_bureau ON bureau_balance_summary (sk_id_bureau);

-- 2. bureau: noi summary theo khoan vay, sau do gom ve dung 1 dong cho moi khach hang.
DROP TABLE IF EXISTS bureau_summary CASCADE;

CREATE TABLE bureau_summary AS
SELECT
    b.sk_id_curr,
    COUNT(*)                   AS bureau_count,
    SUM(b.amt_credit_sum)      AS bureau_sum_credit,
    SUM(b.amt_credit_sum_debt) AS bureau_sum_debt,
    MAX(b.credit_day_overdue)  AS bureau_max_overdue,
    AVG(b.days_credit)         AS bureau_avg_days_credit,
    MAX(b.days_credit)         AS bureau_latest_days_credit,
    COUNT(*) FILTER (WHERE COALESCE(bb.bureau_balance_dpd_month_count, 0) > 0) AS bureau_balance_delinquent_loan_count,
    SUM(COALESCE(bb.bureau_balance_dpd_month_count, 0)) AS bureau_balance_dpd_month_count,
    MAX(COALESCE(bb.bureau_balance_max_dpd_status, 0)) AS bureau_balance_max_dpd_status,
    SUM(COALESCE(bb.bureau_balance_closed_month_count, 0)) AS bureau_balance_closed_month_count,
    SUM(COALESCE(bb.bureau_balance_unknown_month_count, 0)) AS bureau_balance_unknown_month_count,
    SUM(COALESCE(bb.bureau_balance_month_count, 0)) AS bureau_balance_month_count
FROM bureau b
LEFT JOIN bureau_balance_summary bb ON bb.sk_id_bureau = b.sk_id_bureau
GROUP BY b.sk_id_curr;

CREATE UNIQUE INDEX idx_bureau_summary_curr ON bureau_summary (sk_id_curr);

-- 3. previous_application
DROP TABLE IF EXISTS previous_application_summary CASCADE;

CREATE TABLE previous_application_summary AS
SELECT
    sk_id_curr,
    COUNT(*)           AS previous_count,
    SUM(amt_credit)    AS previous_sum_credit,
    AVG(amt_credit)    AS previous_avg_credit,
    AVG(days_decision) AS previous_avg_days_decision,
    MAX(days_decision) AS previous_latest_decision
FROM previous_application
GROUP BY sk_id_curr;

CREATE UNIQUE INDEX idx_previous_application_summary_curr ON previous_application_summary (sk_id_curr);

-- 4. installments_payments
DROP TABLE IF EXISTS installments_payments_summary CASCADE;

CREATE TABLE installments_payments_summary AS
SELECT
    sk_id_curr,
    COUNT(*)                                  AS installments_count,
    SUM(amt_instalment)                       AS installments_sum_due,
    SUM(amt_payment)                          AS installments_sum_paid,
    AVG(days_entry_payment - days_instalment) AS installments_avg_late,
    MAX(days_entry_payment - days_instalment) AS installments_max_late
FROM installments_payments
GROUP BY sk_id_curr;

CREATE UNIQUE INDEX idx_installments_payments_summary_curr ON installments_payments_summary (sk_id_curr);

-- 5. pos_cash_balance
DROP TABLE IF EXISTS pos_cash_balance_summary CASCADE;

CREATE TABLE pos_cash_balance_summary AS
SELECT
    sk_id_curr,
    COUNT(*)            AS pos_cash_count,
    AVG(sk_dpd)         AS pos_cash_avg_dpd,
    MAX(sk_dpd)         AS pos_cash_max_dpd,
    MIN(months_balance) AS pos_cash_oldest_month,
    MAX(months_balance) AS pos_cash_latest_month
FROM pos_cash_balance
GROUP BY sk_id_curr;

CREATE UNIQUE INDEX idx_pos_cash_balance_summary_curr ON pos_cash_balance_summary (sk_id_curr);

-- 6. credit_card_balance
DROP TABLE IF EXISTS credit_card_balance_summary CASCADE;

CREATE TABLE credit_card_balance_summary AS
SELECT
    sk_id_curr,
    COUNT(*)                     AS credit_card_count,
    AVG(amt_balance)             AS credit_card_avg_balance,
    MAX(amt_balance)             AS credit_card_max_balance,
    AVG(amt_credit_limit_actual) AS credit_card_avg_limit,
    MAX(sk_dpd)                  AS credit_card_max_dpd
FROM credit_card_balance
GROUP BY sk_id_curr;

CREATE UNIQUE INDEX idx_credit_card_balance_summary_curr ON credit_card_balance_summary (sk_id_curr);
