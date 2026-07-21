-- 07_check_summary_grain.sql
-- Muc dich: kiem chung moi bang summary chi con dung 1 dong cho moi khach hang.
-- Neu total_rows = distinct_customers thi bang da dat muc du lieu 1 dong / 1 khach,
-- tuc la join vao application_train se khong lam no so dong.

SELECT 'bureau_summary' AS table_name,
       COUNT(*)::BIGINT AS total_rows,
       COUNT(DISTINCT sk_id_curr)::BIGINT AS distinct_customers,
       CASE WHEN COUNT(*) = COUNT(DISTINCT sk_id_curr) THEN 'OK' ELSE 'CAN_KIEM_TRA' END AS result
FROM bureau_summary
UNION ALL
SELECT 'previous_summary', COUNT(*)::BIGINT, COUNT(DISTINCT sk_id_curr)::BIGINT,
       CASE WHEN COUNT(*) = COUNT(DISTINCT sk_id_curr) THEN 'OK' ELSE 'CAN_KIEM_TRA' END
FROM previous_summary
UNION ALL
SELECT 'installments_summary', COUNT(*)::BIGINT, COUNT(DISTINCT sk_id_curr)::BIGINT,
       CASE WHEN COUNT(*) = COUNT(DISTINCT sk_id_curr) THEN 'OK' ELSE 'CAN_KIEM_TRA' END
FROM installments_summary
UNION ALL
SELECT 'pos_cash_summary', COUNT(*)::BIGINT, COUNT(DISTINCT sk_id_curr)::BIGINT,
       CASE WHEN COUNT(*) = COUNT(DISTINCT sk_id_curr) THEN 'OK' ELSE 'CAN_KIEM_TRA' END
FROM pos_cash_summary
UNION ALL
SELECT 'credit_card_summary', COUNT(*)::BIGINT, COUNT(DISTINCT sk_id_curr)::BIGINT,
       CASE WHEN COUNT(*) = COUNT(DISTINCT sk_id_curr) THEN 'OK' ELSE 'CAN_KIEM_TRA' END
FROM credit_card_summary;
