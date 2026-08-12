-- 02_import_data.sql
-- Muc dich: import 7 file CSV raw vao PostgreSQL bang pgAdmin Query Tool.
-- Luu y: COPY doc file tu may PostgreSQL server, nen duong dan ben duoi can ton tai voi server.
-- Neu may thanh vien dat project o thu muc khac, hay sua lai duong dan truoc khi chay.
-- Danh sach cot duoc khai bao tuong minh de COPY khong phu thuoc vao thu tu cot vat ly cua bang.

TRUNCATE TABLE
    applications,
    bureau,
    bureau_balance,
    previous_application,
    installments_payments,
    pos_cash_balance,
    credit_card_balance;

COPY applications (
    sk_id_curr, target, name_contract_type, code_gender, flag_own_car, flag_own_realty,
    cnt_children, amt_income_total, amt_credit, amt_annuity, amt_goods_price, name_type_suite,
    name_income_type, name_education_type, name_family_status, name_housing_type,
    region_population_relative, days_birth, days_employed, days_registration, days_id_publish,
    own_car_age, flag_mobil, flag_emp_phone, flag_work_phone, flag_cont_mobile, flag_phone,
    flag_email, occupation_type, cnt_fam_members, region_rating_client,
    region_rating_client_w_city, weekday_appr_process_start, hour_appr_process_start,
    reg_region_not_live_region, reg_region_not_work_region, live_region_not_work_region,
    reg_city_not_live_city, reg_city_not_work_city, live_city_not_work_city, organization_type,
    ext_source_1, ext_source_2, ext_source_3, apartments_avg, basementarea_avg,
    years_beginexpluatation_avg, years_build_avg, commonarea_avg, elevators_avg, entrances_avg,
    floorsmax_avg, floorsmin_avg, landarea_avg, livingapartments_avg, livingarea_avg,
    nonlivingapartments_avg, nonlivingarea_avg, apartments_mode, basementarea_mode,
    years_beginexpluatation_mode, years_build_mode, commonarea_mode, elevators_mode,
    entrances_mode, floorsmax_mode, floorsmin_mode, landarea_mode, livingapartments_mode,
    livingarea_mode, nonlivingapartments_mode, nonlivingarea_mode, apartments_medi,
    basementarea_medi, years_beginexpluatation_medi, years_build_medi, commonarea_medi,
    elevators_medi, entrances_medi, floorsmax_medi, floorsmin_medi, landarea_medi,
    livingapartments_medi, livingarea_medi, nonlivingapartments_medi, nonlivingarea_medi,
    fondkapremont_mode, housetype_mode, totalarea_mode, wallsmaterial_mode, emergencystate_mode,
    obs_30_cnt_social_circle, def_30_cnt_social_circle, obs_60_cnt_social_circle,
    def_60_cnt_social_circle, days_last_phone_change, flag_document_2, flag_document_3,
    flag_document_4, flag_document_5, flag_document_6, flag_document_7, flag_document_8,
    flag_document_9, flag_document_10, flag_document_11, flag_document_12, flag_document_13,
    flag_document_14, flag_document_15, flag_document_16, flag_document_17, flag_document_18,
    flag_document_19, flag_document_20, flag_document_21, amt_req_credit_bureau_hour,
    amt_req_credit_bureau_day, amt_req_credit_bureau_week, amt_req_credit_bureau_mon,
    amt_req_credit_bureau_qrt, amt_req_credit_bureau_year
)
FROM 'D:/FPT Polytechnic/2026/HK Summer 2026/Block2/Du-an-01/credit-risk-classifier/data/raw/applications.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '', QUOTE '"');

COPY bureau (
    sk_id_curr, sk_id_bureau, credit_active, credit_currency, days_credit, credit_day_overdue,
    days_credit_enddate, days_enddate_fact, amt_credit_max_overdue, cnt_credit_prolong,
    amt_credit_sum, amt_credit_sum_debt, amt_credit_sum_limit, amt_credit_sum_overdue,
    credit_type, days_credit_update, amt_annuity
)
FROM 'D:/FPT Polytechnic/2026/HK Summer 2026/Block2/Du-an-01/credit-risk-classifier/data/raw/bureau.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '', QUOTE '"');

COPY bureau_balance (
    sk_id_bureau, months_balance, status
)
FROM 'D:/FPT Polytechnic/2026/HK Summer 2026/Block2/Du-an-01/credit-risk-classifier/data/raw/bureau_balance.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '', QUOTE '"');

COPY previous_application (
    sk_id_prev, sk_id_curr, name_contract_type, amt_annuity, amt_application, amt_credit,
    amt_down_payment, amt_goods_price, weekday_appr_process_start, hour_appr_process_start,
    flag_last_appl_per_contract, nflag_last_appl_in_day, rate_down_payment,
    rate_interest_primary, rate_interest_privileged, name_cash_loan_purpose,
    name_contract_status, days_decision, name_payment_type, code_reject_reason, name_type_suite,
    name_client_type, name_goods_category, name_portfolio, name_product_type, channel_type,
    sellerplace_area, name_seller_industry, cnt_payment, name_yield_group, product_combination,
    days_first_drawing, days_first_due, days_last_due_1st_version, days_last_due,
    days_termination, nflag_insured_on_approval
)
FROM 'D:/FPT Polytechnic/2026/HK Summer 2026/Block2/Du-an-01/credit-risk-classifier/data/raw/previous_application.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '', QUOTE '"');

COPY installments_payments (
    sk_id_prev, sk_id_curr, num_instalment_version, num_instalment_number, days_instalment,
    days_entry_payment, amt_instalment, amt_payment
)
FROM 'D:/FPT Polytechnic/2026/HK Summer 2026/Block2/Du-an-01/credit-risk-classifier/data/raw/installments_payments.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '', QUOTE '"');

COPY pos_cash_balance (
    sk_id_prev, sk_id_curr, months_balance, cnt_instalment, cnt_instalment_future,
    name_contract_status, sk_dpd, sk_dpd_def
)
FROM 'D:/FPT Polytechnic/2026/HK Summer 2026/Block2/Du-an-01/credit-risk-classifier/data/raw/POS_CASH_balance.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '', QUOTE '"');

COPY credit_card_balance (
    sk_id_prev, sk_id_curr, months_balance, amt_balance, amt_credit_limit_actual,
    amt_drawings_atm_current, amt_drawings_current, amt_drawings_other_current,
    amt_drawings_pos_current, amt_inst_min_regularity, amt_payment_current,
    amt_payment_total_current, amt_receivable_principal, amt_recivable,
    amt_total_receivable, cnt_drawings_atm_current, cnt_drawings_current,
    cnt_drawings_other_current, cnt_drawings_pos_current, cnt_instalment_mature_cum,
    name_contract_status, sk_dpd, sk_dpd_def
)
FROM 'D:/FPT Polytechnic/2026/HK Summer 2026/Block2/Du-an-01/credit-risk-classifier/data/raw/credit_card_balance.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '', QUOTE '"');
