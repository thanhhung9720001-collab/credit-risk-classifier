-- 09_check_flat_rows.sql
-- Muc dich: kiem tra application_flat giu dung so dong va khong nhan ban ban ghi.
-- Giai thich chi tiet: xem Muc 7.1 trong notebook 02.

SELECT
    'so_dong' AS kiem_tra,
    307511::BIGINT AS gia_tri_mong_doi,
    COUNT(*)::BIGINT AS gia_tri_thuc_te,
    CASE WHEN COUNT(*) = 307511 THEN 'OK' ELSE 'CAN_KIEM_TRA' END AS result
FROM application_flat
UNION ALL
SELECT
    'so_khach_hang_rieng_biet',
    307511::BIGINT,
    COUNT(DISTINCT sk_id_curr)::BIGINT,
    CASE WHEN COUNT(DISTINCT sk_id_curr) = 307511 THEN 'OK' ELSE 'CAN_KIEM_TRA' END
FROM application_flat
UNION ALL
SELECT
    'so_cot',
    148::BIGINT,
    COUNT(*)::BIGINT,
    CASE WHEN COUNT(*) = 148 THEN 'OK' ELSE 'CAN_KIEM_TRA' END
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'application_flat';
