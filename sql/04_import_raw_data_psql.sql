-- 04_import_raw_data_psql.sql
-- Muc dich: import 8 file CSV raw bang psql va lenh \copy.
-- Chay lenh nay tu thu muc goc project:
-- psql -h localhost -U postgres -d credit_risk_db -f sql/04_import_raw_data_psql.sql

TRUNCATE TABLE
    application_train,
    application_test,
    bureau,
    bureau_balance,
    previous_application,
    installments_payments,
    pos_cash_balance,
    credit_card_balance;

\copy application_train FROM 'data/raw/application_train.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '', QUOTE '"')
\copy application_test FROM 'data/raw/application_test.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '', QUOTE '"')
\copy bureau FROM 'data/raw/bureau.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '', QUOTE '"')
\copy bureau_balance FROM 'data/raw/bureau_balance.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '', QUOTE '"')
\copy previous_application FROM 'data/raw/previous_application.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '', QUOTE '"')
\copy installments_payments FROM 'data/raw/installments_payments.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '', QUOTE '"')
\copy pos_cash_balance FROM 'data/raw/POS_CASH_balance.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '', QUOTE '"')
\copy credit_card_balance FROM 'data/raw/credit_card_balance.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '', QUOTE '"')
