-- 08_create_application_flat.sql
-- Muc dich: gop application_train voi 5 bang summary thanh bang phang 1 khach = 1 dong.
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

    p.previous_count,
    p.previous_sum_credit,
    p.previous_avg_credit,
    p.previous_avg_days_decision,
    p.previous_latest_decision,

    i.installments_count,
    i.installments_sum_due,
    i.installments_sum_paid,
    i.installments_avg_late,
    i.installments_max_late,

    pc.pos_cash_count,
    pc.pos_cash_avg_dpd,
    pc.pos_cash_max_dpd,
    pc.pos_cash_oldest_month,
    pc.pos_cash_latest_month,

    cc.credit_card_count,
    cc.credit_card_avg_balance,
    cc.credit_card_max_balance,
    cc.credit_card_avg_limit,
    cc.credit_card_max_dpd
FROM application_train a
LEFT JOIN bureau_summary         b   ON b.sk_id_curr = a.sk_id_curr
LEFT JOIN previous_summary       p   ON p.sk_id_curr = a.sk_id_curr
LEFT JOIN installments_summary   i   ON i.sk_id_curr = a.sk_id_curr
LEFT JOIN pos_cash_summary       pc  ON pc.sk_id_curr = a.sk_id_curr
LEFT JOIN credit_card_summary    cc  ON cc.sk_id_curr = a.sk_id_curr;

CREATE UNIQUE INDEX idx_application_flat_curr ON application_flat (sk_id_curr);
