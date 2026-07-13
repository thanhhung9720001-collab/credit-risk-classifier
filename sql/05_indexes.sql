-- ============================================================================
-- DỰ ÁN 1: XÂY DỰNG MÔ HÌNH PHÂN LOẠI VÀ DỰ BÁO RỦI RO KHÁCH HÀNG VAY VỐN
-- Script 05: Tạo các chỉ mục (Indexes) tối ưu hóa hiệu năng truy vấn
-- Tác giả: Nguyễn Bá Gia Huy (huy)
-- Ngày tạo: 2026-07-09
-- ============================================================================

-- Lưu ý: Khóa chính (sk_id_curr, sk_id_bureau, sk_id_prev) đã được PostgreSQL tự động tạo index.
-- Chúng ta cần tạo chỉ mục cho các cột khóa ngoại thường dùng làm điều kiện JOIN.

-- 1. Chỉ mục trên bảng bureau
CREATE INDEX IF NOT EXISTS idx_bureau_curr ON bureau (sk_id_curr);

-- 2. Chỉ mục trên bảng bureau_balance
CREATE INDEX IF NOT EXISTS idx_bureau_balance_bureau ON bureau_balance (sk_id_bureau);

-- 3. Chỉ mục trên bảng previous_application
CREATE INDEX IF NOT EXISTS idx_prev_app_curr ON previous_application (sk_id_curr);

-- 4. Chỉ mục trên bảng pos_cash_balance
CREATE INDEX IF NOT EXISTS idx_pos_cash_curr ON pos_cash_balance (sk_id_curr);
CREATE INDEX IF NOT EXISTS idx_pos_cash_prev ON pos_cash_balance (sk_id_prev);

-- 5. Chỉ mục trên bảng installments_payments
CREATE INDEX IF NOT EXISTS idx_installments_curr ON installments_payments (sk_id_curr);
CREATE INDEX IF NOT EXISTS idx_installments_prev ON installments_payments (sk_id_prev);

-- 6. Chỉ mục trên bảng credit_card_balance
CREATE INDEX IF NOT EXISTS idx_credit_card_curr ON credit_card_balance (sk_id_curr);
CREATE INDEX IF NOT EXISTS idx_credit_card_prev ON credit_card_balance (sk_id_prev);
