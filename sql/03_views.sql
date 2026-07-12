-- ============================================================================
-- DỰ ÁN 1: XÂY DỰNG MÔ HÌNH PHÂN LOẠI VÀ DỰ BÁO RỦI RO KHÁCH HÀNG VAY VỐN
-- Script 03: Tạo các View nghiệp vụ (Business Views) có giải thích chi tiết
-- Tác giả: Nguyễn Thành Hưng (hung)
-- Ngày tạo: 2026-07-12
-- ============================================================================

-- Dọn dẹp các view cũ nếu tồn tại để tránh xung đột cấu trúc cột khi định nghĩa lại
DROP VIEW IF EXISTS v_application_all CASCADE;
DROP VIEW IF EXISTS v_bureau_clean CASCADE;
DROP VIEW IF EXISTS v_bureau_balance_summary CASCADE;
DROP VIEW IF EXISTS v_previous_application_clean CASCADE;
DROP VIEW IF EXISTS v_installments_detail CASCADE;
DROP VIEW IF EXISTS v_pos_cash_clean CASCADE;
DROP VIEW IF EXISTS v_credit_card_clean CASCADE;

-- ============================================================================
-- 1. VIEW v_application_all: Gộp toàn bộ đơn vay (Train & Test)
-- ============================================================================
-- Ý NGHĨA: 
--   Gộp bảng Train (dữ liệu lịch sử đã có nhãn Target) và bảng Test (dữ liệu mới cần
--   dự đoán) làm một bảng ảo duy nhất.
-- TẠI SAO CẦN:
--   Khi thực hiện tiền xử lý (xử lý giá trị trống, mã hóa biến phân loại...) trong 
--   Jupyter Notebook, chúng ta chỉ cần chạy code làm sạch trên view này đúng 1 lần, 
--   thay vì viết code giống hệt nhau cho 2 bảng riêng biệt.
-- GIẢI THÍCH CỘT THÊM VÀO:
--   - is_train: Nhận giá trị 1 cho đơn Train, 0 cho đơn Test để phân biệt.
--   - target: Giữ nguyên nhãn của Train (1: nợ xấu, 0: nợ tốt). Ở bảng Test, cột này
--             được gán mặc định là NULL vì chưa biết nhãn.
-- ============================================================================
CREATE OR REPLACE VIEW v_application_all AS
SELECT 
    1 AS is_train,
    target,
    sk_id_curr, name_contract_type, code_gender, flag_own_car, flag_own_realty, cnt_children, amt_income_total, amt_credit, amt_annuity, amt_goods_price, name_type_suite, name_income_type, name_education_type, name_family_status, name_housing_type, region_population_relative, days_birth, days_employed, days_registration, days_id_publish, own_car_age, flag_mobil, flag_emp_phone, flag_work_phone, flag_cont_mobile, flag_phone, flag_email, occupation_type, cnt_fam_members, region_rating_client, region_rating_client_w_city, weekday_appr_process_start, hour_appr_process_start, reg_region_not_live_region, reg_region_not_work_region, live_region_not_work_region, reg_city_not_live_city, reg_city_not_work_city, live_city_not_work_city, organization_type, ext_source_1, ext_source_2, ext_source_3, apartments_avg, basementarea_avg, years_beginexpluatation_avg, years_build_avg, commonarea_avg, elevators_avg, entrances_avg, floorsmax_avg, floorsmin_avg, landarea_avg, livingapartments_avg, livingarea_avg, nonlivingapartments_avg, nonlivingarea_avg, apartments_mode, basementarea_mode, years_beginexpluatation_mode, years_build_mode, commonarea_mode, elevators_mode, entrances_mode, floorsmax_mode, floorsmin_mode, landarea_mode, livingapartments_mode, livingarea_mode, nonlivingapartments_mode, nonlivingarea_mode, apartments_medi, basementarea_medi, years_beginexpluatation_medi, years_build_medi, commonarea_medi, elevators_medi, entrances_medi, floorsmax_medi, floorsmin_medi, landarea_medi, livingapartments_medi, livingarea_medi, nonlivingapartments_medi, nonlivingarea_medi, fondkapremont_mode, housetype_mode, totalarea_mode, wallsmaterial_mode, emergencystate_mode, obs_30_cnt_social_circle, def_30_cnt_social_circle, obs_60_cnt_social_circle, def_60_cnt_social_circle, days_last_phone_change, flag_document_2, flag_document_3, flag_document_4, flag_document_5, flag_document_6, flag_document_7, flag_document_8, flag_document_9, flag_document_10, flag_document_11, flag_document_12, flag_document_13, flag_document_14, flag_document_15, flag_document_16, flag_document_17, flag_document_18, flag_document_19, flag_document_20, flag_document_21, amt_req_credit_bureau_hour, amt_req_credit_bureau_day, amt_req_credit_bureau_week, amt_req_credit_bureau_mon, amt_req_credit_bureau_qrt, amt_req_credit_bureau_year
FROM application_train
UNION ALL
SELECT 
    0 AS is_train,
    NULL AS target,
    sk_id_curr, name_contract_type, code_gender, flag_own_car, flag_own_realty, cnt_children, amt_income_total, amt_credit, amt_annuity, amt_goods_price, name_type_suite, name_income_type, name_education_type, name_family_status, name_housing_type, region_population_relative, days_birth, days_employed, days_registration, days_id_publish, own_car_age, flag_mobil, flag_emp_phone, flag_work_phone, flag_cont_mobile, flag_phone, flag_email, occupation_type, cnt_fam_members, region_rating_client, region_rating_client_w_city, weekday_appr_process_start, hour_appr_process_start, reg_region_not_live_region, reg_region_not_work_region, live_region_not_work_region, reg_city_not_live_city, reg_city_not_work_city, live_city_not_work_city, organization_type, ext_source_1, ext_source_2, ext_source_3, apartments_avg, basementarea_avg, years_beginexpluatation_avg, years_build_avg, commonarea_avg, elevators_avg, entrances_avg, floorsmax_avg, floorsmin_avg, landarea_avg, livingapartments_avg, livingarea_avg, nonlivingapartments_avg, nonlivingarea_avg, apartments_mode, basementarea_mode, years_beginexpluatation_mode, years_build_mode, commonarea_mode, elevators_mode, entrances_mode, floorsmax_mode, floorsmin_mode, landarea_mode, livingapartments_mode, livingarea_mode, nonlivingapartments_mode, nonlivingarea_mode, apartments_medi, basementarea_medi, years_beginexpluatation_medi, years_build_medi, commonarea_medi, elevators_medi, entrances_medi, floorsmax_medi, floorsmin_medi, landarea_medi, livingapartments_medi, livingarea_medi, nonlivingapartments_medi, nonlivingarea_medi, fondkapremont_mode, housetype_mode, totalarea_mode, wallsmaterial_mode, emergencystate_mode, obs_30_cnt_social_circle, def_30_cnt_social_circle, obs_60_cnt_social_circle, def_60_cnt_social_circle, days_last_phone_change, flag_document_2, flag_document_3, flag_document_4, flag_document_5, flag_document_6, flag_document_7, flag_document_8, flag_document_9, flag_document_10, flag_document_11, flag_document_12, flag_document_13, flag_document_14, flag_document_15, flag_document_16, flag_document_17, flag_document_18, flag_document_19, flag_document_20, flag_document_21, amt_req_credit_bureau_hour, amt_req_credit_bureau_day, amt_req_credit_bureau_week, amt_req_credit_bureau_mon, amt_req_credit_bureau_qrt, amt_req_credit_bureau_year
FROM application_test;

-- ============================================================================
-- 2. VIEW v_bureau_clean: Làm sạch thông tin lịch sử tín dụng ngoài (CIC)
-- ============================================================================
-- Ý NGHĨA: 
--   Chứa thông tin các khoản nợ cũ của khách hàng tại các ngân hàng khác.
-- GIẢI THÍCH CÁC PHÉP TÍNH:
--   - amt_credit_sum_limit_unused: Hạn mức tín dụng còn lại chưa sử dụng.
--   - debt_credit_ratio: Tỷ lệ Dư nợ / Hạn mức vay (Dư nợ thực tế chiếm bao nhiêu % 
--     hạn mức được cấp). Tỷ lệ này càng cao chứng tỏ khách hàng càng phụ thuộc 
--     vào nợ vay, rủi ro tài chính cao hơn.
-- ============================================================================
CREATE OR REPLACE VIEW v_bureau_clean AS
SELECT 
    sk_id_curr,
    sk_id_bureau,
    credit_active,
    credit_currency,
    days_credit,
    credit_day_overdue,
    days_credit_enddate,
    days_enddate_fact,
    amt_credit_max_overdue,
    cnt_credit_prolong,
    amt_credit_sum,
    amt_credit_sum_debt,
    amt_credit_sum_limit,
    amt_credit_sum_overdue,
    credit_type,
    days_credit_update,
    amt_annuity,
    -- Hạn mức chưa tiêu dùng hết (Số tiền được cấp - Số tiền đang nợ)
    COALESCE(amt_credit_sum, 0) - COALESCE(amt_credit_sum_debt, 0) AS amt_credit_sum_limit_unused,
    -- Tỷ lệ dư nợ trên hạn mức (Tránh chia cho 0 nếu hạn mức sum = 0)
    CASE 
        WHEN COALESCE(amt_credit_sum, 0) > 0 THEN COALESCE(amt_credit_sum_debt, 0) / amt_credit_sum 
        ELSE 0 
    END AS debt_credit_ratio
FROM bureau;

-- ============================================================================
-- 3. VIEW v_installments_detail: Chi tiết lịch sử thanh toán trả góp
-- ============================================================================
-- Ý NGHĨA:
--   Theo dõi chi tiết hành vi đóng tiền định kỳ của khách hàng tại Home Credit.
-- GIẢI THÍCH CÁC PHÉP TÍNH:
--   - days_late: Số ngày đóng tiền muộn của khách hàng so với lịch hẹn đóng. 
--     Nếu đóng sớm hoặc đúng hạn, trả về 0 ngày.
--   - amt_underpaid: Số tiền đóng thiếu trong kỳ. Nếu đóng dư hoặc đủ, trả về 0.
-- TẠI SAO CẦN:
--   Đây là biến cực kỳ mạnh để phát hiện thói quen trả nợ của khách hàng. Khách
--   hàng thường xuyên đóng trễ hoặc thiếu tiền có khả năng vỡ nợ rất cao.
-- ============================================================================
CREATE OR REPLACE VIEW v_installments_detail AS
SELECT 
    sk_id_prev,
    sk_id_curr,
    num_instalment_version,
    num_instalment_number,
    days_instalment,
    days_entry_payment,
    amt_instalment,
    amt_payment,
    -- Ngày trễ hạn thực tế (nếu ngày đóng thực tế lớn hơn ngày phải đóng theo lịch)
    CASE 
        WHEN days_entry_payment > days_instalment THEN days_entry_payment - days_instalment 
        ELSE 0 
    END AS days_late,
    -- Số tiền đóng thiếu (nếu số tiền phải đóng lớn hơn số tiền thực tế đóng)
    CASE 
        WHEN amt_instalment > amt_payment THEN amt_instalment - amt_payment 
        ELSE 0 
    END AS amt_underpaid
FROM installments_payments;

-- ============================================================================
-- 4. VIEW v_pos_cash_clean: Trạng thái số dư khoản vay tiêu dùng (POS/CASH)
-- ============================================================================
-- Ý NGHĨA:
--   Xem xét lịch sử đóng tiền của các khoản vay mua trả góp POS (như mua điện thoại,
--   tủ lạnh...) hoặc vay tiền mặt tiêu dùng.
-- GIẢI THÍCH CÁC PHÉP TÍNH:
--   - is_overdue: Đánh dấu 1 nếu tháng đó khoản vay đang bị quá hạn đóng (sk_dpd > 0),
--     đánh dấu 0 nếu đóng bình thường.
-- ============================================================================
CREATE OR REPLACE VIEW v_pos_cash_clean AS
SELECT 
    sk_id_prev,
    sk_id_curr,
    months_balance,
    cnt_instalment,
    cnt_instalment_future,
    name_contract_status,
    sk_dpd,
    sk_dpd_def,
    -- Đánh dấu nhị phân xem tháng đó khách hàng có bị trễ hạn hay không
    CASE WHEN sk_dpd > 0 THEN 1 ELSE 0 END AS is_overdue
FROM pos_cash_balance;

-- ============================================================================
-- 5. VIEW v_credit_card_clean: Hành vi sử dụng và thanh toán thẻ tín dụng
-- ============================================================================
-- Ý NGHĨA:
--   Theo dõi chi tiết thói quen tiêu xài, rút tiền và đóng tiền thẻ tín dụng hàng tháng.
-- GIẢI THÍCH CÁC PHÉP TÍNH:
--   - card_utilization_ratio: Tỷ lệ sử dụng thẻ (Dư nợ thẻ hiện tại / Hạn mức thẻ). 
--     Người thường xuyên tiêu chạm hạn mức (tỷ lệ gần 1) biểu thị rủi ro tín dụng 
--     cao do thiếu hụt tiền mặt dự phòng.
-- ============================================================================
CREATE OR REPLACE VIEW v_credit_card_clean AS
SELECT 
    sk_id_prev,
    sk_id_curr,
    months_balance,
    amt_balance,
    amt_credit_limit_actual,
    amt_drawings_atm_current,
    amt_drawings_current,
    amt_drawings_other_current,
    amt_drawings_pos_current,
    amt_inst_min_regularity,
    amt_payment_current,
    amt_payment_total_current,
    amt_receivable_principal,
    amt_recivable,
    amt_total_receivable,
    cnt_drawings_atm_current,
    cnt_drawings_current,
    cnt_drawings_other_current,
    cnt_drawings_pos_current,
    cnt_instalment_mature_cum,
    name_contract_status,
    sk_dpd,
    sk_dpd_def,
    -- Tỷ lệ sử dụng hạn mức thẻ tín dụng (Tránh chia cho 0 nếu hạn mức thẻ = 0)
    CASE 
        WHEN amt_credit_limit_actual > 0 THEN amt_balance / amt_credit_limit_actual 
        ELSE 0 
    END AS card_utilization_ratio
FROM credit_card_balance;

-- ============================================================================
-- 6. VIEW v_previous_application_clean: Chi tiết hồ sơ vay cũ tại Home Credit
-- ============================================================================
-- Ý NGHĨA:
--   Chứa thông tin các hồ sơ cũ mà khách hàng từng nộp tại chính Home Credit.
-- GIẢI THÍCH CÁC PHÉP TÍNH:
--   - approved_applied_ratio: Tỷ lệ Số tiền được duyệt / Số tiền đăng ký vay.
--     Nếu tỷ lệ này thấp (ví dụ: < 0.5), chứng tỏ khách hàng bị Home Credit cắt giảm
--     số tiền giải ngân do đánh giá rủi ro cao.
--   - is_approved / is_refused / is_canceled: Đánh dấu trạng thái hồ sơ (Duyệt, 
--     Từ chối, hoặc Hủy bỏ) để đo lường mức độ uy tín của khách hàng trong quá khứ.
-- ============================================================================
CREATE OR REPLACE VIEW v_previous_application_clean AS
SELECT 
    sk_id_prev,
    sk_id_curr,
    name_contract_type,
    amt_annuity,
    amt_application,
    amt_credit,
    amt_down_payment,
    amt_goods_price,
    name_contract_status,
    days_decision,
    cnt_payment,
    -- Tỷ lệ số tiền được duyệt so với số tiền đăng ký vay
    CASE 
        WHEN COALESCE(amt_application, 0) > 0 THEN COALESCE(amt_credit, 0) / amt_application 
        ELSE 0 
    END AS approved_applied_ratio,
    -- Phân loại nhị phân trạng thái hồ sơ
    CASE WHEN name_contract_status = 'Approved' THEN 1 ELSE 0 END AS is_approved,
    CASE WHEN name_contract_status = 'Refused' THEN 1 ELSE 0 END AS is_refused,
    CASE WHEN name_contract_status = 'Canceled' THEN 1 ELSE 0 END AS is_canceled
FROM previous_application;

-- ============================================================================
-- 7. VIEW v_bureau_balance_summary: Tổng kết lịch sử số dư nợ ngoài CIC theo tháng
-- ============================================================================
-- Ý NGHĨA:
--   Bảng bureau_balance có hàng chục triệu dòng ghi nhận trạng thái thanh toán hàng
--   tháng cho từng khoản vay ngoài. View này gom nhóm lại cấp độ từng khoản vay (sk_id_bureau).
-- GIẢI THÍCH CÁC PHÉP TÍNH:
--   - total_months: Tổng số tháng ghi nhận lịch sử của khoản vay này.
--   - overdue_months: Số tháng khách hàng bị đóng tiền trễ (trạng thái '1' đến '5').
--   - max_overdue_status: Nhóm nợ cao nhất trong lịch sử (từ 0 đến 5).
-- ============================================================================
CREATE OR REPLACE VIEW v_bureau_balance_summary AS
SELECT 
    sk_id_bureau,
    COUNT(months_balance) AS total_months,
    SUM(CASE WHEN status IN ('1', '2', '3', '4', '5') THEN 1 ELSE 0 END) AS overdue_months,
    -- Tìm nhóm nợ trễ hạn cao nhất (0: bình thường, 1-5: tăng dần mức độ trễ hạn)
    MAX(CASE 
        WHEN status = '5' THEN 5 
        WHEN status = '4' THEN 4 
        WHEN status = '3' THEN 3 
        WHEN status = '2' THEN 2 
        WHEN status = '1' THEN 1 
        WHEN status = '0' THEN 0 
        ELSE 0 
    END) AS max_overdue_status
FROM bureau_balance
GROUP BY sk_id_bureau;
