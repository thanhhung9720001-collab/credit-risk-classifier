-- 10_check_flat_target.sql
-- Muc dich: doi chieu phan bo TARGET giua application_train va application_flat.
-- Hai dong ket qua phai giong het nhau. Neu join lam mat khach hang thi ty le lech ngay.
-- Giai thich chi tiet: xem Muc 7.2 trong notebook 02.

SELECT
    'application_train' AS bang,
    COUNT(*)::BIGINT AS tong_dong,
    SUM(CASE WHEN target = 1 THEN 1 ELSE 0 END)::BIGINT AS so_target_1,
    SUM(CASE WHEN target = 0 THEN 1 ELSE 0 END)::BIGINT AS so_target_0,
    ROUND(100.0 * SUM(CASE WHEN target = 1 THEN 1 ELSE 0 END) / COUNT(*), 3) AS ty_le_target_1
FROM application_train
UNION ALL
SELECT
    'application_flat',
    COUNT(*)::BIGINT,
    SUM(CASE WHEN target = 1 THEN 1 ELSE 0 END)::BIGINT,
    SUM(CASE WHEN target = 0 THEN 1 ELSE 0 END)::BIGINT,
    ROUND(100.0 * SUM(CASE WHEN target = 1 THEN 1 ELSE 0 END) / COUNT(*), 3)
FROM application_flat;
