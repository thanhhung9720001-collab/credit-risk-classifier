-- 08_create_application_flat.sql
-- Muc dich: gop applications voi 5 bang summary thanh bang phang 1 khach = 1 dong.
-- Giai thich chi tiet: xem Muc 6 trong notebook 02.

DROP TABLE IF EXISTS application_flat CASCADE;

CREATE TABLE application_flat AS
SELECT
    a.*,
    b.bureau_count,
    b.bureau_sum_credit,
    b.bureau_sum_debt,
    b.bureau_max_overdue,
    b.bureau_avg_days_credit,
    b.bureau_latest_days_credit,
    b.bureau_recent_loan_12m_count,
    b.bureau_recent_12m_overdue_count,
    b.bureau_active_count,
    b.bureau_closed_count,
    b.bureau_sum_overdue,
    b.bureau_overdue_loan_count,
    b.bureau_balance_delinquent_loan_count,
    b.bureau_balance_dpd_month_count,
    b.bureau_balance_max_dpd_status,
    b.bureau_balance_closed_month_count,
    b.bureau_balance_unknown_month_count,
    b.bureau_balance_month_count,

    p.previous_count,
    p.previous_sum_credit,
    p.previous_approved_sum_credit,
    p.previous_avg_credit,
    p.previous_avg_days_decision,
    p.previous_latest_decision,
    p.previous_approved_count,
    p.previous_refused_count,
    p.previous_recent_12m_count,
    p.previous_recent_12m_approved_count,
    p.previous_recent_12m_refused_count,

    i.installments_count,
    i.installments_sum_due,
    i.installments_sum_paid,
    i.installments_avg_late,
    i.installments_max_late,
    i.installments_late_count,
    i.installments_underpaid_count,
    i.installments_underpaid_amount,
    i.installments_recent_12m_late_count,
    i.installments_recent_12m_count,
    i.installments_recent_12m_underpaid_count,
    i.installments_recent_12m_underpaid_amount,

    pc.pos_cash_count,
    pc.pos_cash_avg_dpd,
    pc.pos_cash_max_dpd,
    pc.pos_cash_oldest_month,
    pc.pos_cash_latest_month,
    pc.pos_cash_contract_count,
    pc.pos_cash_recent_12m_dpd_count,
    pc.pos_cash_recent_12m_max_dpd,

    cc.credit_card_count,
    cc.credit_card_avg_balance,
    cc.credit_card_max_balance,
    cc.credit_card_avg_limit,
    cc.credit_card_max_dpd,
    cc.credit_card_contract_count,
    cc.credit_card_avg_utilization,
    cc.credit_card_max_utilization,
    cc.credit_card_recent_12m_max_utilization
FROM applications a
LEFT JOIN bureau_summary         b   ON b.sk_id_curr = a.sk_id_curr
LEFT JOIN previous_application_summary   p   ON p.sk_id_curr = a.sk_id_curr
LEFT JOIN installments_payments_summary   i   ON i.sk_id_curr = a.sk_id_curr
LEFT JOIN pos_cash_balance_summary        pc  ON pc.sk_id_curr = a.sk_id_curr
LEFT JOIN credit_card_balance_summary     cc  ON cc.sk_id_curr = a.sk_id_curr;

CREATE UNIQUE INDEX idx_application_flat_curr ON application_flat (sk_id_curr);
