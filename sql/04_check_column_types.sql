-- 04_check_column_types.sql
-- Muc dich: kiem tra kieu du lieu sau import co dung nhu thiet ke trong 01_create_tables.sql hay khong.
-- COPY ghep du lieu THEO VI TRI COT chu khong theo ten cot, nen neu so cot lech thi
-- du lieu co the vao nham cot ma van import thanh cong, khong bao loi.
-- Cot kieu chu cung phai dung so luong: mot cot dang le la so ma khai thanh TEXT
-- se lam SUM/AVG bao loi va MAX so sanh theo bang chu cai (vi du '9' > '2792').

SELECT
    mong_doi.table_name,
    mong_doi.so_cot_mong_doi,
    COUNT(cols.column_name) AS so_cot_thuc_te,
    mong_doi.so_cot_chu_mong_doi,
    SUM(CASE WHEN cols.data_type = 'text' THEN 1 ELSE 0 END) AS so_cot_chu_thuc_te,
    CASE
        WHEN COUNT(cols.column_name) = mong_doi.so_cot_mong_doi
         AND SUM(CASE WHEN cols.data_type = 'text' THEN 1 ELSE 0 END) = mong_doi.so_cot_chu_mong_doi
        THEN 'OK'
        ELSE 'CAN_KIEM_TRA'
    END AS result,
    STRING_AGG(DISTINCT cols.data_type, ', ' ORDER BY cols.data_type) AS cac_kieu_du_lieu
FROM (VALUES
    ('application_train',     122, 16),
    ('application_test',      121, 16),
    ('bureau',                 17,  3),
    ('bureau_balance',          3,  1),
    ('previous_application',   37, 16),
    ('installments_payments',   8,  0),
    ('pos_cash_balance',        8,  1),
    ('credit_card_balance',    23,  1)
) AS mong_doi (table_name, so_cot_mong_doi, so_cot_chu_mong_doi)
LEFT JOIN information_schema.columns AS cols
       ON cols.table_schema = 'public'
      AND cols.table_name = mong_doi.table_name
GROUP BY mong_doi.table_name, mong_doi.so_cot_mong_doi, mong_doi.so_cot_chu_mong_doi
ORDER BY mong_doi.table_name;
