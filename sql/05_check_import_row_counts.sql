-- 05_check_import_row_counts.sql
-- Muc dich: kiem tra so dong sau import co khop voi ket qua da ghi nhan o NB01 hay khong.

SELECT 'application_train' AS table_name, 307511::BIGINT AS expected_rows, COUNT(*)::BIGINT AS actual_rows,
       CASE WHEN COUNT(*) = 307511 THEN 'OK' ELSE 'CAN_KIEM_TRA' END AS result
FROM application_train
UNION ALL
SELECT 'application_test', 48744::BIGINT, COUNT(*)::BIGINT,
       CASE WHEN COUNT(*) = 48744 THEN 'OK' ELSE 'CAN_KIEM_TRA' END
FROM application_test
UNION ALL
SELECT 'bureau', 1716428::BIGINT, COUNT(*)::BIGINT,
       CASE WHEN COUNT(*) = 1716428 THEN 'OK' ELSE 'CAN_KIEM_TRA' END
FROM bureau
UNION ALL
SELECT 'bureau_balance', 27299925::BIGINT, COUNT(*)::BIGINT,
       CASE WHEN COUNT(*) = 27299925 THEN 'OK' ELSE 'CAN_KIEM_TRA' END
FROM bureau_balance
UNION ALL
SELECT 'previous_application', 1670214::BIGINT, COUNT(*)::BIGINT,
       CASE WHEN COUNT(*) = 1670214 THEN 'OK' ELSE 'CAN_KIEM_TRA' END
FROM previous_application
UNION ALL
SELECT 'installments_payments', 13605401::BIGINT, COUNT(*)::BIGINT,
       CASE WHEN COUNT(*) = 13605401 THEN 'OK' ELSE 'CAN_KIEM_TRA' END
FROM installments_payments
UNION ALL
SELECT 'pos_cash_balance', 10001358::BIGINT, COUNT(*)::BIGINT,
       CASE WHEN COUNT(*) = 10001358 THEN 'OK' ELSE 'CAN_KIEM_TRA' END
FROM pos_cash_balance
UNION ALL
SELECT 'credit_card_balance', 3840312::BIGINT, COUNT(*)::BIGINT,
       CASE WHEN COUNT(*) = 3840312 THEN 'OK' ELSE 'CAN_KIEM_TRA' END
FROM credit_card_balance;
