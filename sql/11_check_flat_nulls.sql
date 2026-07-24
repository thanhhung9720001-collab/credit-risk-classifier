-- 11_check_flat_nulls.sql
-- Muc dich: chung minh cac o NULL sau LEFT JOIN la dung, khong phai do join lam mat du lieu.
-- so_dong_null   : dem thang tren application_flat.
-- null_mong_doi  : tinh tu chinh database = so khach cua application_train
--                  tru di so khach co mat trong bang summary tuong ung.
-- Hai con so bang nhau nghia la LEFT JOIN khong danh roi khach hang nao.
-- Giai thich chi tiet: xem Muc 7.3 trong notebook 02.

SELECT
    nhom_cot,
    so_dong_null,
    null_mong_doi,
    CASE WHEN so_dong_null = null_mong_doi THEN 'OK' ELSE 'CAN_KIEM_TRA' END AS result
FROM (
    SELECT
        'bureau' AS nhom_cot,
        (SELECT COUNT(*) FROM application_flat WHERE bureau_count IS NULL)::BIGINT AS so_dong_null,
        ((SELECT COUNT(*) FROM application_train)
         - (SELECT COUNT(*) FROM bureau_summary s
            JOIN application_train a ON a.sk_id_curr = s.sk_id_curr))::BIGINT AS null_mong_doi
    UNION ALL
    SELECT
        'previous_application',
        (SELECT COUNT(*) FROM application_flat WHERE previous_count IS NULL)::BIGINT,
        ((SELECT COUNT(*) FROM application_train)
         - (SELECT COUNT(*) FROM previous_application_summary s
            JOIN application_train a ON a.sk_id_curr = s.sk_id_curr))::BIGINT
    UNION ALL
    SELECT
        'installments_payments',
        (SELECT COUNT(*) FROM application_flat WHERE installments_count IS NULL)::BIGINT,
        ((SELECT COUNT(*) FROM application_train)
         - (SELECT COUNT(*) FROM installments_payments_summary s
            JOIN application_train a ON a.sk_id_curr = s.sk_id_curr))::BIGINT
    UNION ALL
    SELECT
        'pos_cash_balance',
        (SELECT COUNT(*) FROM application_flat WHERE pos_cash_count IS NULL)::BIGINT,
        ((SELECT COUNT(*) FROM application_train)
         - (SELECT COUNT(*) FROM pos_cash_balance_summary s
            JOIN application_train a ON a.sk_id_curr = s.sk_id_curr))::BIGINT
    UNION ALL
    SELECT
        'credit_card_balance',
        (SELECT COUNT(*) FROM application_flat WHERE credit_card_count IS NULL)::BIGINT,
        ((SELECT COUNT(*) FROM application_train)
         - (SELECT COUNT(*) FROM credit_card_balance_summary s
            JOIN application_train a ON a.sk_id_curr = s.sk_id_curr))::BIGINT
) AS ket_qua
ORDER BY nhom_cot;
