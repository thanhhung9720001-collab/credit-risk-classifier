-- 05_create_indexes.sql
-- Muc dich: tao index tren cac khoa noi truoc khi tao bang summary va bang phang.
-- Index giup PostgreSQL tim nhanh cac dong theo khoa thay vi quet ca bang.
-- Chay file nay sau khi da import du lieu raw va kiem tra so dong.

-- Khoa chinh cua bang trung tam, dung khi join voi cac bang summary o Muc 6.
DROP INDEX IF EXISTS idx_application_train_curr;
CREATE INDEX idx_application_train_curr ON application_train (sk_id_curr);

DROP INDEX IF EXISTS idx_application_test_curr;
CREATE INDEX idx_application_test_curr ON application_test (sk_id_curr);

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

-- bureau_balance khong co sk_id_curr, phai noi vong qua bureau bang sk_id_bureau.
-- Hai index duoi day phuc vu dung phep noi do.
DROP INDEX IF EXISTS idx_bureau_bureau_id;
CREATE INDEX idx_bureau_bureau_id ON bureau (sk_id_bureau);

DROP INDEX IF EXISTS idx_bureau_balance_bureau_id;
CREATE INDEX idx_bureau_balance_bureau_id ON bureau_balance (sk_id_bureau);
