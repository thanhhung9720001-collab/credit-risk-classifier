-- 02_import_data.sql
-- Muc dich: import 8 file CSV raw vao PostgreSQL bang pgAdmin Query Tool.
-- Luu y: COPY doc file tu may PostgreSQL server, nen duong dan ben duoi can ton tai voi server.
-- Neu may thanh vien dat project o thu muc khac, hay sua lai duong dan truoc khi chay.

TRUNCATE TABLE
    application_train,
    application_test,
    bureau,
    bureau_balance,
    previous_application,
    installments_payments,
    pos_cash_balance,
    credit_card_balance;

COPY application_train
FROM 'D:/FPT Polytechnic/2026/HK Summer 2026/Block2/Du-an-01/credit-risk-classifier/data/raw/application_train.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '', QUOTE '"');

COPY application_test
FROM 'D:/FPT Polytechnic/2026/HK Summer 2026/Block2/Du-an-01/credit-risk-classifier/data/raw/application_test.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '', QUOTE '"');

COPY bureau
FROM 'D:/FPT Polytechnic/2026/HK Summer 2026/Block2/Du-an-01/credit-risk-classifier/data/raw/bureau.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '', QUOTE '"');

COPY bureau_balance
FROM 'D:/FPT Polytechnic/2026/HK Summer 2026/Block2/Du-an-01/credit-risk-classifier/data/raw/bureau_balance.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '', QUOTE '"');

COPY previous_application
FROM 'D:/FPT Polytechnic/2026/HK Summer 2026/Block2/Du-an-01/credit-risk-classifier/data/raw/previous_application.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '', QUOTE '"');

COPY installments_payments
FROM 'D:/FPT Polytechnic/2026/HK Summer 2026/Block2/Du-an-01/credit-risk-classifier/data/raw/installments_payments.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '', QUOTE '"');

COPY pos_cash_balance
FROM 'D:/FPT Polytechnic/2026/HK Summer 2026/Block2/Du-an-01/credit-risk-classifier/data/raw/POS_CASH_balance.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '', QUOTE '"');

COPY credit_card_balance
FROM 'D:/FPT Polytechnic/2026/HK Summer 2026/Block2/Du-an-01/credit-risk-classifier/data/raw/credit_card_balance.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '', QUOTE '"');
