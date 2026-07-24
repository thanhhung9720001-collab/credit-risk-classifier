-- 07_check_summary_grain.sql
-- Muc dich: kiem chung moi bang summary chi con dung 1 dong theo khoa gom nhom.
-- bureau_balance_summary dung 1 dong / SK_ID_BUREAU; cac bang con lai dung 1 dong / SK_ID_CURR.

SELECT 'bureau_balance_summary' AS table_name,
       COUNT(*)::BIGINT AS total_rows,
       COUNT(DISTINCT sk_id_bureau)::BIGINT AS distinct_keys,
       CASE WHEN COUNT(*) = COUNT(DISTINCT sk_id_bureau) THEN 'OK' ELSE 'CAN_KIEM_TRA' END AS result
FROM bureau_balance_summary
UNION ALL
SELECT 'bureau_summary', COUNT(*)::BIGINT, COUNT(DISTINCT sk_id_curr)::BIGINT,
       CASE WHEN COUNT(*) = COUNT(DISTINCT sk_id_curr) THEN 'OK' ELSE 'CAN_KIEM_TRA' END
FROM bureau_summary
UNION ALL
SELECT 'previous_application_summary', COUNT(*)::BIGINT, COUNT(DISTINCT sk_id_curr)::BIGINT,
       CASE WHEN COUNT(*) = COUNT(DISTINCT sk_id_curr) THEN 'OK' ELSE 'CAN_KIEM_TRA' END
FROM previous_application_summary
UNION ALL
SELECT 'installments_payments_summary', COUNT(*)::BIGINT, COUNT(DISTINCT sk_id_curr)::BIGINT,
       CASE WHEN COUNT(*) = COUNT(DISTINCT sk_id_curr) THEN 'OK' ELSE 'CAN_KIEM_TRA' END
FROM installments_payments_summary
UNION ALL
SELECT 'pos_cash_balance_summary', COUNT(*)::BIGINT, COUNT(DISTINCT sk_id_curr)::BIGINT,
       CASE WHEN COUNT(*) = COUNT(DISTINCT sk_id_curr) THEN 'OK' ELSE 'CAN_KIEM_TRA' END
FROM pos_cash_balance_summary
UNION ALL
SELECT 'credit_card_balance_summary', COUNT(*)::BIGINT, COUNT(DISTINCT sk_id_curr)::BIGINT,
       CASE WHEN COUNT(*) = COUNT(DISTINCT sk_id_curr) THEN 'OK' ELSE 'CAN_KIEM_TRA' END
FROM credit_card_balance_summary;
