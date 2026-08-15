# ============================================================
# 1. IMPORT THƯ VIỆN
# ============================================================

import requests
import pandas as pd
import streamlit as st

# ============================================================
# 2. CẤU HÌNH STREAMLIT
# ============================================================

st.set_page_config(
    page_title="Credit Risk Prediction",
    page_icon="📊",
    layout="wide",
    initial_sidebar_state="expanded",
)

st.title("Phân loại và Dự báo Rủi ro Khách hàng Vay vốn")

st.caption(
    "Ứng dụng sử dụng FastAPI và mô hình HistGradientBoosting "
    "để hỗ trợ đánh giá rủi ro tín dụng."
)

# ============================================================
# 3. KHAI BÁO FASTAPI URL
# ============================================================

API_BASE_URL = "http://127.0.0.1:8000"


def check_api_health():
    """
    Kiểm tra FastAPI có đang hoạt động hay không.
    """
    try:
        response = requests.get(
            f"{API_BASE_URL}/health",
            timeout=5,
        )

        if response.status_code == 200:
            return True, response.json()

        return False, None

    except requests.RequestException:
        return False, None

api_ok, health_data = check_api_health()

if api_ok:
    st.success("FastAPI đang hoạt động.")
else:
    st.error(
        "Không kết nối được FastAPI. "
        "Hãy chạy api.py trước khi sử dụng ứng dụng."
    )

# ============================================================
# 4. HELPER FUNCTIONS GỌI FASTAPI
# ============================================================


def get_dashboard_data():
    """
    Lấy dữ liệu tổng quan từ endpoint /dashboard.
    """
    try:
        response = requests.get(
            f"{API_BASE_URL}/dashboard",
            timeout=10,
        )
        response.raise_for_status()
        return response.json()

    except requests.RequestException as error:
        st.error(f"Lỗi khi lấy dữ liệu dashboard: {error}")
        return None


def predict_customer_api(sk_id_curr: int):
    """
    Gọi endpoint /predict để dự đoán một khách hàng.
    """
    try:
        response = requests.post(
            f"{API_BASE_URL}/predict",
            json={"sk_id_curr": sk_id_curr},
            timeout=10,
        )

        if response.status_code == 404:
            return None, "Không tìm thấy khách hàng."

        response.raise_for_status()
        return response.json(), None

    except requests.RequestException as error:
        return None, f"Lỗi khi gọi API: {error}"


def predict_batch_api(sk_id_curr_list: list[int]):
    """
    Gọi endpoint /predict_batch để dự đoán nhiều khách hàng.
    """
    try:
        response = requests.post(
            f"{API_BASE_URL}/predict_batch",
            json={"sk_id_curr_list": sk_id_curr_list},
            timeout=30,
        )

        response.raise_for_status()
        return response.json(), None

    except requests.RequestException as error:
        return None, f"Lỗi khi gọi API: {error}"


def get_applications(limit: int = 20, offset: int = 0):
    """
    Lấy danh sách hồ sơ khách hàng.
    """
    try:
        response = requests.get(
            f"{API_BASE_URL}/applications",
            params={
                "limit": limit,
                "offset": offset,
            },
            timeout=10,
        )

        response.raise_for_status()
        return response.json(), None

    except requests.RequestException as error:
        return None, f"Lỗi khi lấy danh sách khách hàng: {error}"


def get_application_detail(sk_id_curr: int):
    """
    Lấy thông tin chi tiết của một khách hàng.
    """
    try:
        response = requests.get(
            f"{API_BASE_URL}/applications/{sk_id_curr}",
            timeout=10,
        )

        if response.status_code == 404:
            return None, "Không tìm thấy khách hàng."

        response.raise_for_status()
        return response.json(), None

    except requests.RequestException as error:
        return None, f"Lỗi khi lấy thông tin khách hàng: {error}"


# ============================================================
# 5. SIDEBAR VÀ ĐIỀU HƯỚNG
# ============================================================

st.sidebar.title("Điều hướng")

page = st.sidebar.radio(
    "Chọn chức năng",
    [
        "Dashboard",
        "Dự đoán đơn",
        "Dự đoán theo lô",
        "Tra cứu khách hàng",
    ],
)

st.sidebar.divider()

if api_ok and health_data:
    st.sidebar.success("FastAPI: Online")

    st.sidebar.write(
        f"Model: {health_data.get('model', 'N/A')}"
    )

    st.sidebar.write(
        f"Số feature: {health_data.get('features_count', 'N/A')}"
    )

    st.sidebar.write(
        f"Threshold: {health_data.get('decision_threshold', 'N/A')}"
    )

else:
    st.sidebar.error("FastAPI: Offline")


# ============================================================
# TÊN HIỂN THỊ TIẾNG VIỆT CHO FEATURE
# ============================================================

FEATURE_LABELS = {
    # ========================================================
    # THÔNG TIN ĐỊNH DANH VÀ MỤC TIÊU
    # ========================================================
    "sk_id_curr": "Mã khách hàng",
    "target": "Nhãn thực tế",

    # ========================================================
    # THÔNG TIN HỒ SƠ KHÁCH HÀNG
    # ========================================================
    "name_contract_type": "Loại hợp đồng vay",
    "code_gender": "Giới tính",
    "flag_own_car": "Sở hữu ô tô",
    "flag_own_realty": "Sở hữu bất động sản",
    "cnt_children": "Số con",
    "amt_income_total": "Tổng thu nhập",
    "amt_credit": "Số tiền vay",
    "amt_annuity": "Khoản trả góp",
    "amt_goods_price": "Giá trị hàng hóa",
    "name_type_suite": "Người đi cùng khi đăng ký",
    "name_income_type": "Loại thu nhập",
    "name_education_type": "Trình độ học vấn",
    "name_family_status": "Tình trạng hôn nhân",
    "name_housing_type": "Loại hình nhà ở",
    "region_population_relative": "Tỷ lệ dân số tương đối của khu vực",
    "days_birth": "Số ngày tính từ ngày sinh",
    "days_employed": "Số ngày làm việc",
    "days_registration": "Số ngày kể từ khi đăng ký",
    "days_id_publish": "Số ngày kể từ khi cấp giấy tờ",
    "own_car_age": "Tuổi của ô tô",

    # ========================================================
    # THÔNG TIN LIÊN LẠC VÀ VIỆC LÀM
    # ========================================================
    "flag_mobil": "Có số điện thoại di động",
    "flag_emp_phone": "Có điện thoại nơi làm việc",
    "flag_work_phone": "Có điện thoại công việc",
    "flag_cont_mobile": "Điện thoại di động có thể liên lạc",
    "flag_phone": "Có số điện thoại",
    "flag_email": "Có email",
    "occupation_type": "Nghề nghiệp",
    "cnt_fam_members": "Số thành viên gia đình",
    "region_rating_client": "Xếp hạng khu vực của khách hàng",
    "region_rating_client_w_city": "Xếp hạng khu vực có xét thành phố",
    "weekday_appr_process_start": "Thứ bắt đầu xử lý hồ sơ",
    "hour_appr_process_start": "Giờ bắt đầu xử lý hồ sơ",

    # ========================================================
    # KHÁC BIỆT ĐỊA CHỈ
    # ========================================================
    "reg_region_not_live_region": "Khu vực đăng ký khác khu vực sinh sống",
    "reg_region_not_work_region": "Khu vực đăng ký khác khu vực làm việc",
    "live_region_not_work_region": "Khu vực sinh sống khác khu vực làm việc",
    "reg_city_not_live_city": "Thành phố đăng ký khác thành phố sinh sống",
    "reg_city_not_work_city": "Thành phố đăng ký khác thành phố làm việc",
    "live_city_not_work_city": "Thành phố sinh sống khác thành phố làm việc",
    "organization_type": "Loại hình tổ chức làm việc",

    # ========================================================
    # NGUỒN ĐÁNH GIÁ BÊN NGOÀI
    # ========================================================
    "ext_source_1": "Điểm tín dụng ngoài 1",
    "ext_source_2": "Điểm tín dụng ngoài 2",
    "ext_source_3": "Điểm tín dụng ngoài 3",

    # ========================================================
    # THÔNG TIN BẤT ĐỘNG SẢN - GIÁ TRỊ TRUNG BÌNH
    # ========================================================
    "apartments_avg": "Tỷ lệ căn hộ trung bình",
    "basementarea_avg": "Diện tích tầng hầm trung bình",
    "years_beginexpluatation_avg": "Năm bắt đầu sử dụng trung bình",
    "years_build_avg": "Năm xây dựng trung bình",
    "commonarea_avg": "Diện tích dùng chung trung bình",
    "elevators_avg": "Số thang máy trung bình",
    "entrances_avg": "Số lối vào trung bình",
    "floorsmax_avg": "Số tầng tối đa trung bình",
    "floorsmin_avg": "Số tầng tối thiểu trung bình",
    "landarea_avg": "Diện tích đất trung bình",
    "livingapartments_avg": "Diện tích căn hộ ở trung bình",
    "livingarea_avg": "Diện tích sinh hoạt trung bình",
    "nonlivingapartments_avg": "Diện tích căn hộ không ở trung bình",
    "nonlivingarea_avg": "Diện tích không sinh hoạt trung bình",

    # ========================================================
    # THÔNG TIN BẤT ĐỘNG SẢN - GIÁ TRỊ MODE
    # ========================================================
    "apartments_mode": "Tỷ lệ căn hộ phổ biến",
    "basementarea_mode": "Diện tích tầng hầm phổ biến",
    "years_beginexpluatation_mode": "Năm bắt đầu sử dụng phổ biến",
    "years_build_mode": "Năm xây dựng phổ biến",
    "commonarea_mode": "Diện tích dùng chung phổ biến",
    "elevators_mode": "Số thang máy phổ biến",
    "entrances_mode": "Số lối vào phổ biến",
    "floorsmax_mode": "Số tầng tối đa phổ biến",
    "floorsmin_mode": "Số tầng tối thiểu phổ biến",
    "landarea_mode": "Diện tích đất phổ biến",
    "livingapartments_mode": "Diện tích căn hộ ở phổ biến",
    "livingarea_mode": "Diện tích sinh hoạt phổ biến",
    "nonlivingapartments_mode": "Diện tích căn hộ không ở phổ biến",
    "nonlivingarea_mode": "Diện tích không sinh hoạt phổ biến",

    # ========================================================
    # THÔNG TIN BẤT ĐỘNG SẢN - TRUNG VỊ
    # ========================================================
    "apartments_medi": "Tỷ lệ căn hộ trung vị",
    "basementarea_medi": "Diện tích tầng hầm trung vị",
    "years_beginexpluatation_medi": "Năm bắt đầu sử dụng trung vị",
    "years_build_medi": "Năm xây dựng trung vị",
    "commonarea_medi": "Diện tích dùng chung trung vị",
    "elevators_medi": "Số thang máy trung vị",
    "entrances_medi": "Số lối vào trung vị",
    "floorsmax_medi": "Số tầng tối đa trung vị",
    "floorsmin_medi": "Số tầng tối thiểu trung vị",
    "landarea_medi": "Diện tích đất trung vị",
    "livingapartments_medi": "Diện tích căn hộ ở trung vị",
    "livingarea_medi": "Diện tích sinh hoạt trung vị",
    "nonlivingapartments_medi": "Diện tích căn hộ không ở trung vị",
    "nonlivingarea_medi": "Diện tích không sinh hoạt trung vị",

    # ========================================================
    # ĐẶC ĐIỂM NHÀ Ở
    # ========================================================
    "fondkapremont_mode": "Loại quỹ sửa chữa nhà",
    "housetype_mode": "Loại nhà",
    "totalarea_mode": "Tổng diện tích nhà",
    "wallsmaterial_mode": "Vật liệu tường",
    "emergencystate_mode": "Tình trạng khẩn cấp của nhà",

    # ========================================================
    # VÒNG QUAN HỆ XÃ HỘI
    # ========================================================
    "obs_30_cnt_social_circle": "Số người quen được quan sát trong 30 ngày",
    "def_30_cnt_social_circle": "Số người quen vi phạm trong 30 ngày",
    "obs_60_cnt_social_circle": "Số người quen được quan sát trong 60 ngày",
    "def_60_cnt_social_circle": "Số người quen vi phạm trong 60 ngày",
    "days_last_phone_change": "Số ngày từ lần đổi điện thoại gần nhất",

    # ========================================================
    # GIẤY TỜ
    # ========================================================
    "flag_document_2": "Có giấy tờ loại 2",
    "flag_document_3": "Có giấy tờ loại 3",
    "flag_document_4": "Có giấy tờ loại 4",
    "flag_document_5": "Có giấy tờ loại 5",
    "flag_document_6": "Có giấy tờ loại 6",
    "flag_document_7": "Có giấy tờ loại 7",
    "flag_document_8": "Có giấy tờ loại 8",
    "flag_document_9": "Có giấy tờ loại 9",
    "flag_document_10": "Có giấy tờ loại 10",
    "flag_document_11": "Có giấy tờ loại 11",
    "flag_document_12": "Có giấy tờ loại 12",
    "flag_document_13": "Có giấy tờ loại 13",
    "flag_document_14": "Có giấy tờ loại 14",
    "flag_document_15": "Có giấy tờ loại 15",
    "flag_document_16": "Có giấy tờ loại 16",
    "flag_document_17": "Có giấy tờ loại 17",
    "flag_document_18": "Có giấy tờ loại 18",
    "flag_document_19": "Có giấy tờ loại 19",
    "flag_document_20": "Có giấy tờ loại 20",
    "flag_document_21": "Có giấy tờ loại 21",

    # ========================================================
    # YÊU CẦU TRA CỨU TÍN DỤNG
    # ========================================================
    "amt_req_credit_bureau_hour": "Số yêu cầu tra cứu tín dụng trong giờ",
    "amt_req_credit_bureau_day": "Số yêu cầu tra cứu tín dụng trong ngày",
    "amt_req_credit_bureau_week": "Số yêu cầu tra cứu tín dụng trong tuần",
    "amt_req_credit_bureau_mon": "Số yêu cầu tra cứu tín dụng trong tháng",
    "amt_req_credit_bureau_qrt": "Số yêu cầu tra cứu tín dụng trong quý",
    "amt_req_credit_bureau_year": "Số yêu cầu tra cứu tín dụng trong năm",

    # ========================================================
    # LỊCH SỬ TÍN DỤNG BUREAU
    # ========================================================
    "bureau_count": "Số khoản tín dụng trong Bureau",
    "bureau_sum_credit": "Tổng số tiền tín dụng Bureau",
    "bureau_sum_debt": "Tổng dư nợ Bureau",
    "bureau_max_overdue": "Khoản quá hạn lớn nhất trong Bureau",
    "bureau_avg_days_credit": "Số ngày tín dụng trung bình trong Bureau",
    "bureau_latest_days_credit": "Khoản tín dụng Bureau gần nhất",
    "bureau_recent_loan_12m_count": "Số khoản vay Bureau trong 12 tháng gần đây",
    "bureau_recent_12m_overdue_count": "Số khoản quá hạn Bureau trong 12 tháng gần đây",
    "bureau_active_count": "Số khoản tín dụng Bureau đang hoạt động",
    "bureau_closed_count": "Số khoản tín dụng Bureau đã đóng",
    "bureau_sum_overdue": "Tổng tiền quá hạn Bureau",
    "bureau_overdue_loan_count": "Số khoản vay Bureau bị quá hạn",

    # ========================================================
    # BUREAU BALANCE
    # ========================================================
    "bureau_balance_delinquent_loan_count": "Số khoản vay Bureau từng chậm trả",
    "bureau_balance_dpd_month_count": "Số tháng chậm trả trong Bureau Balance",
    "bureau_balance_max_dpd_status": "Mức chậm trả cao nhất trong Bureau Balance",
    "bureau_balance_closed_month_count": "Số tháng trạng thái đã đóng trong Bureau Balance",
    "bureau_balance_unknown_month_count": "Số tháng không xác định trong Bureau Balance",
    "bureau_balance_month_count": "Tổng số tháng lịch sử Bureau Balance",

    # ========================================================
    # HỒ SƠ VAY TRƯỚC
    # ========================================================
    "previous_count": "Số hồ sơ vay trước",
    "previous_sum_credit": "Tổng số tiền vay trước",
    "previous_approved_sum_credit": "Tổng tiền vay trước được duyệt",
    "previous_avg_credit": "Khoản vay trước trung bình",
    "previous_avg_days_decision": "Số ngày ra quyết định trung bình của hồ sơ trước",
    "previous_latest_decision": "Thời điểm quyết định hồ sơ trước gần nhất",
    "previous_approved_count": "Số hồ sơ trước được duyệt",
    "previous_refused_count": "Số hồ sơ trước bị từ chối",
    "previous_recent_12m_count": "Số hồ sơ vay trước trong 12 tháng gần đây",
    "previous_recent_12m_approved_count": "Số hồ sơ được duyệt trong 12 tháng gần đây",
    "previous_recent_12m_refused_count": "Số hồ sơ bị từ chối trong 12 tháng gần đây",

    # ========================================================
    # THANH TOÁN TRẢ GÓP
    # ========================================================
    "installments_count": "Tổng số kỳ trả góp",
    "installments_sum_due": "Tổng số tiền phải trả",
    "installments_sum_paid": "Tổng số tiền đã thanh toán",
    "installments_avg_late": "Số ngày trả trễ trung bình",
    "installments_max_late": "Số ngày trả trễ lớn nhất",
    "installments_late_count": "Số lần trả trễ",
    "installments_underpaid_count": "Số lần thanh toán thiếu",
    "installments_underpaid_amount": "Tổng số tiền thanh toán thiếu",
    "installments_recent_12m_late_count": "Số lần trả trễ trong 12 tháng gần đây",
    "installments_recent_12m_count": "Số kỳ trả góp trong 12 tháng gần đây",
    "installments_recent_12m_underpaid_count": "Số lần thanh toán thiếu trong 12 tháng gần đây",
    "installments_recent_12m_underpaid_amount": "Tổng tiền thanh toán thiếu trong 12 tháng gần đây",

    # ========================================================
    # POS / CASH
    # ========================================================
    "pos_cash_count": "Số bản ghi POS/CASH",
    "pos_cash_avg_dpd": "Số ngày quá hạn POS/CASH trung bình",
    "pos_cash_max_dpd": "Số ngày quá hạn POS/CASH lớn nhất",
    "pos_cash_oldest_month": "Tháng lịch sử POS/CASH xa nhất",
    "pos_cash_latest_month": "Tháng lịch sử POS/CASH gần nhất",
    "pos_cash_contract_count": "Số hợp đồng POS/CASH",
    "pos_cash_recent_12m_dpd_count": "Số lần quá hạn POS/CASH trong 12 tháng gần đây",
    "pos_cash_recent_12m_max_dpd": "Số ngày quá hạn POS/CASH lớn nhất trong 12 tháng gần đây",

    # ========================================================
    # THẺ TÍN DỤNG
    # ========================================================
    "credit_card_count": "Số bản ghi thẻ tín dụng",
    "credit_card_avg_balance": "Dư nợ thẻ tín dụng trung bình",
    "credit_card_max_balance": "Dư nợ thẻ tín dụng lớn nhất",
    "credit_card_avg_limit": "Hạn mức thẻ tín dụng trung bình",
    "credit_card_max_dpd": "Số ngày quá hạn thẻ tín dụng lớn nhất",
    "credit_card_contract_count": "Số hợp đồng thẻ tín dụng",
    "credit_card_avg_utilization": "Tỷ lệ sử dụng thẻ trung bình",
    "credit_card_max_utilization": "Tỷ lệ sử dụng thẻ cao nhất",
    "credit_card_recent_12m_max_utilization": "Tỷ lệ sử dụng thẻ cao nhất trong 12 tháng gần đây",

    # ========================================================
    # CỜ XÁC ĐỊNH NGUỒN DỮ LIỆU
    # ========================================================
    "has_bureau": "Có lịch sử tín dụng Bureau",
    "has_previous": "Có hồ sơ vay trước",
    "has_installments": "Có lịch sử trả góp",
    "has_pos_cash": "Có lịch sử POS/CASH",
    "has_credit_card": "Có lịch sử thẻ tín dụng",
    "has_credit_bureau_request_info": "Có thông tin yêu cầu tra cứu tín dụng",
    "car_age_missing_when_owned": "Thiếu tuổi ô tô dù có sở hữu ô tô",
    "is_days_employed_special": "Giá trị số ngày làm việc đặc biệt",

    # ========================================================
    # FEATURE ENGINEERING TÀI CHÍNH
    # ========================================================
    "ltv": "Tỷ lệ khoản vay trên giá trị tài sản (LTV)",
    "credit_term": "Kỳ hạn khoản vay",
    "credit_to_income": "Tỷ lệ khoản vay trên thu nhập",
    "dti": "Tỷ lệ nghĩa vụ nợ trên thu nhập (DTI)",
    "income_per_person": "Thu nhập bình quân mỗi thành viên",
    "employment_age_ratio": "Tỷ lệ thời gian làm việc trên tuổi",
    "social_default_ratio_30": "Tỷ lệ vi phạm trong vòng quan hệ 30 ngày",

    # ========================================================
    # FEATURE THỜI GIAN
    # ========================================================
    "age_years": "Tuổi khách hàng",
    "employment_years": "Số năm làm việc",
    "id_publish_years": "Số năm kể từ khi cấp giấy tờ",
    "registration_years": "Số năm kể từ khi đăng ký",
    "phone_change_years": "Số năm kể từ lần đổi điện thoại",
    "application_hour_group": "Nhóm giờ đăng ký hồ sơ",

    # ========================================================
    # FEATURE TỔNG HỢP EXT SOURCE
    # ========================================================
    "ext_sources_mean": "Điểm tín dụng ngoài trung bình",
    "ext_sources_min": "Điểm tín dụng ngoài thấp nhất",
    "ext_sources_std": "Độ lệch chuẩn điểm tín dụng ngoài",

    # ========================================================
    # FEATURE ĐỊA CHỈ
    # ========================================================
    "address_mismatch_count": "Số trường hợp địa chỉ không trùng khớp",

    # ========================================================
    # FEATURE ENGINEERING BUREAU
    # ========================================================
    "bureau_debt_ratio": "Tỷ lệ dư nợ Bureau",
    "bureau_active_ratio": "Tỷ lệ tín dụng Bureau đang hoạt động",
    "bureau_recent_12m_ratio": "Tỷ lệ khoản vay Bureau trong 12 tháng gần đây",
    "bureau_overdue_loan_ratio": "Tỷ lệ khoản vay Bureau quá hạn",
    "bureau_debt_to_income": "Tỷ lệ dư nợ Bureau trên thu nhập",
    "has_bureau_overdue": "Có khoản vay Bureau quá hạn",
    "bureau_recency_days": "Số ngày từ khoản tín dụng Bureau gần nhất",
    "bureau_balance_dpd_month_ratio": "Tỷ lệ tháng chậm trả trong Bureau Balance",

    # ========================================================
    # FEATURE ENGINEERING HỒ SƠ VAY TRƯỚC
    # ========================================================
    "previous_credit_to_current": "Tỷ lệ tín dụng trước so với khoản vay hiện tại",
    "previous_approval_rate": "Tỷ lệ hồ sơ vay trước được duyệt",
    "previous_refusal_rate": "Tỷ lệ hồ sơ vay trước bị từ chối",
    "previous_recent_12m_ratio": "Tỷ lệ hồ sơ vay trước trong 12 tháng gần đây",
    "previous_recency_days": "Số ngày từ hồ sơ vay trước gần nhất",

    # ========================================================
    # FEATURE ENGINEERING TRẢ GÓP
    # ========================================================
    "installments_payment_ratio": "Tỷ lệ số tiền đã thanh toán",
    "installments_late_rate": "Tỷ lệ kỳ trả góp bị trễ",
    "installments_recent_12m_late_rate": "Tỷ lệ trả trễ trong 12 tháng gần đây",
    "installments_recent_12m_underpaid_rate": "Tỷ lệ thanh toán thiếu trong 12 tháng gần đây",
    "has_installments_late": "Có lịch sử trả góp trễ hạn",

    # ========================================================
    # FEATURE ENGINEERING THẺ TÍN DỤNG
    # ========================================================
    "credit_card_utilization": "Tỷ lệ sử dụng hạn mức thẻ tín dụng",
    "credit_card_balance_to_income": "Tỷ lệ dư nợ thẻ trên thu nhập",

    # ========================================================
    # FEATURE ENGINEERING POS/CASH
    # ========================================================
    "has_pos_cash_dpd": "Có lịch sử POS/CASH quá hạn",
    "pos_cash_history_months": "Số tháng lịch sử POS/CASH",

    # ========================================================
    # INTERACTION FEATURES
    # ========================================================
    "age_income_interaction": "Tương tác giữa tuổi và thu nhập",
    "late_debt_interaction": "Tương tác giữa trả trễ và dư nợ",
    "ext_ltv_interaction": "Tương tác điểm tín dụng ngoài và LTV",
    "ext_credit_income_interaction": "Tương tác điểm tín dụng ngoài và tỷ lệ vay trên thu nhập",
    "ext_dti_interaction": "Tương tác điểm tín dụng ngoài và DTI",
    "ext_min_ltv_interaction": "Tương tác điểm tín dụng ngoài thấp nhất và LTV",
    "ext_bureau_debt_interaction": "Tương tác điểm tín dụng ngoài và tỷ lệ dư nợ Bureau",
}


# ============================================================
# 6. DASHBOARD
# ============================================================

if page == "Dashboard":

    st.header("Dashboard tổng quan")

    dashboard_data = get_dashboard_data()

    if dashboard_data:

        total_customers = dashboard_data["total_customers"]
        good_customers = dashboard_data["good_customers"]
        bad_customers = dashboard_data["bad_customers"]
        bad_customer_rate = dashboard_data["bad_customer_rate"]
        avg_income = dashboard_data["avg_income"]
        avg_credit = dashboard_data["avg_credit"]
        avg_annuity = dashboard_data["avg_annuity"]

        # Hàng KPI thứ nhất.
        col1, col2, col3, col4 = st.columns(4)

        col1.metric(
            "Tổng khách hàng",
            f"{total_customers:,}",
        )

        col2.metric(
            "Trả được nợ",
            f"{good_customers:,}",
        )

        col3.metric(
            "Nợ xấu",
            f"{bad_customers:,}",
        )

        col4.metric(
            "Tỷ lệ nợ xấu",
            f"{bad_customer_rate * 100:.2f}%",
        )

        st.divider()

        # Hàng KPI thứ hai.
        col5, col6, col7 = st.columns(3)

        col5.metric(
            "Thu nhập trung bình",
            f"{avg_income:,.0f}",
        )

        col6.metric(
            "Khoản vay trung bình",
            f"{avg_credit:,.0f}",
        )

        col7.metric(
            "Khoản trả góp trung bình",
            f"{avg_annuity:,.0f}",
        )

        st.divider()

        # Biểu đồ phân bố khách hàng theo target.
        chart_data = pd.DataFrame(
            {
                "Nhóm khách hàng": [
                    "Trả được nợ",
                    "Nợ xấu",
                ],
                "Số lượng": [
                    good_customers,
                    bad_customers,
                ],
            }
        )

        st.subheader("Phân bố khách hàng theo rủi ro")

        st.bar_chart(
            chart_data,
            x="Nhóm khách hàng",
            y="Số lượng",
        )

# ============================================================
# 7. DỰ ĐOÁN ĐƠN
# ============================================================

elif page == "Dự đoán đơn":

    st.header("Dự đoán rủi ro một khách hàng")

    st.write(
        "Nhập mã khách hàng `sk_id_curr` để dự đoán "
        "khả năng thuộc nhóm nợ xấu."
    )

    sk_id_curr = st.number_input(
        "Mã khách hàng",
        min_value=1,
        step=1,
        format="%d",
    )

    if st.button(
        "Dự đoán",
        type="primary",
        use_container_width=True,
    ):

        with st.spinner("Đang dự đoán..."):
            result, error = predict_customer_api(
                int(sk_id_curr)
            )

        if error:
            st.error(error)

        elif result:

            prediction = result["prediction"]
            risk_label = result["risk_label"]
            risk_probability = result["risk_probability"]
            threshold = result["decision_threshold"]

            st.subheader("Kết quả dự đoán")

            col1, col2, col3 = st.columns(3)

            col1.metric(
                "Mã khách hàng",
                result["sk_id_curr"],
            )

            col2.metric(
                "Xác suất rủi ro",
                f"{risk_probability * 100:.2f}%",
            )

            col3.metric(
                "Ngưỡng quyết định",
                f"{threshold * 100:.0f}%",
            )

            st.progress(
                min(max(risk_probability, 0.0), 1.0)
            )

            if prediction == 1:
                st.error(
                    f"Kết quả: {risk_label}"
                )
            else:
                st.success(
                    f"Kết quả: {risk_label}"
                )

            st.caption(
                "Khách hàng được phân loại là nợ xấu khi "
                f"xác suất rủi ro lớn hơn hoặc bằng {threshold:.2f}."
            )

# ============================================================
# 8. DỰ ĐOÁN THEO LÔ
# ============================================================

elif page == "Dự đoán theo lô":

    st.header("Dự đoán rủi ro theo lô")

    st.write(
        "Nhập nhiều mã khách hàng `sk_id_curr`, "
        "mỗi mã cách nhau bằng dấu phẩy."
    )

    customer_ids_input = st.text_area(
        "Danh sách mã khách hàng",
        placeholder="Ví dụ: 100002, 100003, 100004",
        height=120,
    )

    if st.button(
        "Dự đoán theo lô",
        type="primary",
        use_container_width=True,
    ):

        if not customer_ids_input.strip():
            st.warning("Vui lòng nhập ít nhất một mã khách hàng.")

        else:
            try:
                sk_id_curr_list = [
                    int(customer_id.strip())
                    for customer_id in customer_ids_input.split(",")
                    if customer_id.strip()
                ]

                if not sk_id_curr_list:
                    st.warning(
                        "Không tìm thấy mã khách hàng hợp lệ."
                    )

                else:
                    with st.spinner("Đang dự đoán..."):
                        result, error = predict_batch_api(
                            sk_id_curr_list
                        )

                    if error:
                        st.error(error)

                    elif result:
                        predictions = result.get(
                            "predictions",
                            [],
                        )

                        st.success(
                            f"Đã dự đoán thành công "
                            f"{len(predictions)} khách hàng."
                        )

                        if predictions:
                            predictions_df = pd.DataFrame(
                                predictions
                            )

                            # Đổi tên cột để hiển thị dễ hiểu.
                            predictions_df = predictions_df.rename(
                                columns={
                                    "sk_id_curr": "Mã khách hàng",
                                    "prediction": "Dự đoán",
                                    "risk_label": "Kết quả",
                                    "risk_probability": "Xác suất rủi ro",
                                    "decision_threshold": "Ngưỡng",
                                }
                            )

                            # Chuyển xác suất sang %.
                            predictions_df["Xác suất rủi ro"] = (
                                predictions_df[
                                    "Xác suất rủi ro"
                                ]
                                * 100
                            ).round(2)

                            predictions_df[
                                "Xác suất rủi ro"
                            ] = predictions_df[
                                "Xác suất rủi ro"
                            ].astype(str) + "%"

                            st.dataframe(
                                predictions_df,
                                use_container_width=True,
                                hide_index=True,
                            )

                        else:
                            st.warning(
                                "Không có khách hàng nào "
                                "được dự đoán."
                            )

            except ValueError:
                st.error(
                    "Danh sách mã khách hàng không hợp lệ. "
                    "Chỉ nhập số và phân cách bằng dấu phẩy."
                )


# ============================================================
# 9. TRA CỨU KHÁCH HÀNG
# ============================================================

elif page == "Tra cứu khách hàng":

    st.header("Tra cứu thông tin khách hàng")

    st.write(
        "Nhập mã khách hàng `sk_id_curr` để xem thông tin hồ sơ."
    )

    customer_id = st.number_input(
        "Mã khách hàng",
        min_value=1,
        step=1,
        format="%d",
        key="lookup_customer_id",
    )

    if st.button(
        "Tra cứu",
        type="primary",
        use_container_width=True,
    ):

        with st.spinner("Đang lấy thông tin khách hàng..."):
            customer_data, error = get_application_detail(
                int(customer_id)
            )

        if error:
            st.error(error)

        elif customer_data:

            st.success("Đã tìm thấy khách hàng.")

            # Thông tin cơ bản.
            st.subheader("Thông tin chính")

            col1, col2, col3, col4 = st.columns(4)

            col1.metric(
                "Mã khách hàng",
                customer_data.get("sk_id_curr", "N/A"),
            )

            target = customer_data.get("target")

            target_label = (
                "Nợ xấu"
                if target == 1
                else "Trả được nợ"
                if target == 0
                else "Chưa xác định"
            )

            col2.metric(
                "Nhãn thực tế",
                target_label,
            )

            col3.metric(
                "Thu nhập",
                f"{customer_data.get('amt_income_total', 0):,.0f}",
            )

            col4.metric(
                "Khoản vay",
                f"{customer_data.get('amt_credit', 0):,.0f}",
            )

            st.divider()

            # Một số thông tin hồ sơ dễ đọc.
            st.subheader("Thông tin hồ sơ")

            profile_data = {
                "Loại hợp đồng": customer_data.get(
                    "name_contract_type"
                ),
                "Giới tính": customer_data.get(
                    "code_gender"
                ),
                "Loại thu nhập": customer_data.get(
                    "name_income_type"
                ),
                "Trình độ học vấn": customer_data.get(
                    "name_education_type"
                ),
                "Tình trạng gia đình": customer_data.get(
                    "name_family_status"
                ),
                "Loại nhà ở": customer_data.get(
                    "name_housing_type"
                ),
                "Nghề nghiệp": customer_data.get(
                    "occupation_type"
                ),
                "Số con": customer_data.get(
                    "cnt_children"
                ),
                "Số thành viên gia đình": customer_data.get(
                    "cnt_fam_members"
                ),
                "Khoản trả góp": customer_data.get(
                    "amt_annuity"
                ),
            }

            profile_df = pd.DataFrame(
                profile_data.items(),
                columns=[
                    "Thông tin",
                    "Giá trị",
                ],
            )

            st.dataframe(
                profile_df,
                use_container_width=True,
                hide_index=True,
            )

            st.divider()

            # Cho phép xem toàn bộ dữ liệu feature.
            with st.expander(
                "Xem toàn bộ dữ liệu khách hàng"
            ):

                full_customer_df = pd.DataFrame(
                    [customer_data]
                ).T.reset_index()

                full_customer_df.columns = [
                    "Feature",
                    "Giá trị",
                ]
                # Đổi tên feature sang tiếng Việt chỉ ở giao diện.
                full_customer_df["Feature"] = full_customer_df["Feature"].apply(
                    lambda feature: FEATURE_LABELS.get(
                        feature,
                        feature,
                )
)

                st.dataframe(
                    full_customer_df,
                    use_container_width=True,
                    hide_index=True,
                )