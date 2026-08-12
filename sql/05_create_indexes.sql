-- 05_create_indexes.sql
-- Muc dich: tao index tren cac khoa noi truoc khi tao bang summary va bang phang.
-- Index ho tro tim kiem va JOIN theo khoa; PostgreSQL co the tan dung tuy execution plan.
-- Chay file nay sau khi da import du lieu raw va kiem tra so dong.

-- applications.sk_id_curr da la PRIMARY KEY, PostgreSQL tu tao unique index.

-- Cac bang phu noi ve khach hang bang sk_id_curr.
DROP INDEX IF EXISTS idx_bureau_curr;
CREATE INDEX idx_bureau_curr ON bureau (sk_id_curr);

DROP INDEX IF EXISTS idx_previous_application_curr;
CREATE INDEX idx_previous_application_curr ON previous_application (sk_id_curr);

DROP INDEX IF EXISTS idx_installments_payments_curr;
CREATE INDEX idx_installments_payments_curr ON installments_payments (sk_id_curr);

DROP INDEX IF EXISTS idx_pos_cash_balance_curr;
CREATE INDEX idx_pos_cash_balance_curr ON pos_cash_balance (sk_id_curr);

DROP INDEX IF EXISTS idx_credit_card_balance_curr;
CREATE INDEX idx_credit_card_balance_curr ON credit_card_balance (sk_id_curr);

-- bureau.sk_id_bureau la PRIMARY KEY nen PostgreSQL da tu tao index cho phep noi nay.
-- Xoa index cu neu database da tung chay pipeline truoc khi khai bao PRIMARY KEY.
DROP INDEX IF EXISTS idx_bureau_bureau_id;
-- bureau_balance khong co sk_id_curr, phai noi vong qua bureau bang sk_id_bureau.
DROP INDEX IF EXISTS idx_bureau_balance_bureau_id;
CREATE INDEX idx_bureau_balance_bureau_id ON bureau_balance (sk_id_bureau);
