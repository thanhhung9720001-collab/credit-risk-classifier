-- ============================================================================
-- DỰ ÁN 1: XÂY DỰNG MÔ HÌNH PHÂN LOẠI VÀ DỰ BÁO RỦI RO KHÁCH HÀNG VAY VỐN
-- Script 05: Tạo các chỉ mục (Indexes) tối ưu hóa hiệu năng truy vấn
-- Tác giả: Phạm Đức Thắng (thang)
-- Ngày tạo: 2026-07-13
-- ============================================================================

-- Bắt đầu giao dịch (Transaction)
BEGIN;

-- ============================================================================
-- PHẦN 1: CHỈ MỤC TRÊN CÁC KHÓA NGOẠI LIÊN KẾT (BASIC FOREIGN KEY INDEXES)
-- Ý nghĩa: Khóa chính (sk_id_curr, sk_id_bureau, sk_id_prev) đã được PostgreSQL
-- tự động tạo index. Chúng ta cần tạo chỉ mục cho các cột đóng vai trò khóa ngoại
-- để tăng tốc các phép JOIN giữa bảng chính và các bảng phụ.
-- ============================================================================

-- 1. Chỉ mục trên bảng bureau
CREATE INDEX IF NOT EXISTS idx_bureau_curr 
ON bureau (sk_id_curr);

-- 2. Chỉ mục trên bảng bureau_balance
CREATE INDEX IF NOT EXISTS idx_bureau_balance_bureau 
ON bureau_balance (sk_id_bureau);

-- 3. Chỉ mục trên bảng previous_application
CREATE INDEX IF NOT EXISTS idx_prev_app_curr 
ON previous_application (sk_id_curr);

-- 4. Chỉ mục trên bảng pos_cash_balance
CREATE INDEX IF NOT EXISTS idx_pos_cash_curr 
ON pos_cash_balance (sk_id_curr);

CREATE INDEX IF NOT EXISTS idx_pos_cash_prev 
ON pos_cash_balance (sk_id_prev);

-- 5. Chỉ mục trên bảng installments_payments
CREATE INDEX IF NOT EXISTS idx_installments_curr 
ON installments_payments (sk_id_curr);

CREATE INDEX IF NOT EXISTS idx_installments_prev 
ON installments_payments (sk_id_prev);

-- 6. Chỉ mục trên bảng credit_card_balance
CREATE INDEX IF NOT EXISTS idx_credit_card_curr 
ON credit_card_balance (sk_id_curr);

CREATE INDEX IF NOT EXISTS idx_credit_card_prev 
ON credit_card_balance (sk_id_prev);


-- ============================================================================
-- PHẦN 2: CHỈ MỤC NÂNG CAO TỐI ƯU TRUY VẤN & GOM NHÓM (ADVANCED INDEXES)
-- Ý nghĩa: Các chỉ mục phức hợp (Composite Indexes) và chỉ mục một phần (Partial Indexes)
-- được thiết kế dựa trên các câu lệnh truy vấn thực tế trong view và bảng tổng hợp.
-- ============================================================================

-- 7. Composite Index trên bảng bureau_balance (sk_id_bureau, status)
-- TẠI SAO CẦN:
--   Bảng bureau_balance rất lớn (~27.3 triệu dòng). View v_bureau_balance_summary 
--   thực hiện gom nhóm theo sk_id_bureau và đếm các trạng thái nợ xấu (status = 1..5).
--   Chỉ mục phức hợp này giúp PostgreSQL thực hiện "Index-Only Scan" (chỉ quét trên index,
--   không cần truy xuất dữ liệu từ bảng vật lý), tăng tốc độ tạo view đáng kể.
CREATE INDEX IF NOT EXISTS idx_bureau_balance_bureau_status 
ON bureau_balance (sk_id_bureau, status);

-- 8. Partial Index trên bảng bureau chỉ lọc các khoản vay đang hoạt động (Active)
-- TẠI SAO CẦN:
--   Trong phân tích rủi ro tín dụng, lịch sử các khoản vay đang hoạt động (credit_active = 'Active')
--   tại các tổ chức tài chính khác thường xuyên được JOIN và phân tích kỹ hơn các khoản vay đã đóng.
--   Partial Index này giúp giảm kích thước chỉ mục và tăng tốc độ lọc các khoản vay Active.
CREATE INDEX IF NOT EXISTS idx_bureau_curr_active 
ON bureau (sk_id_curr) 
WHERE credit_active = 'Active';

-- 9. Index trên cột Target của bảng application_train
-- TẠI SAO CẦN:
--   Cột 'target' dùng để phân loại nợ xấu (1) và nợ tốt (0). Trong quá trình EDA 
--   và huấn luyện mô hình, chúng ta sẽ liên tục lọc dữ liệu theo cột này (ví dụ: WHERE target = 1).
--   Chỉ mục này giúp tối ưu hóa việc phân nhóm và lọc dữ liệu.
CREATE INDEX IF NOT EXISTS idx_application_train_target 
ON application_train (target);

COMMIT;
