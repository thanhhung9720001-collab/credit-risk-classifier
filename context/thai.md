# Context cá nhân — Thái

> Chỉ mình Thái sửa file này. Cập nhật cuối mỗi buổi làm việc rồi commit ngay trong nhánh task của bạn.
> Nhớ khai báo tên đầu phiên: `echo thai > .claude/whoami`

## Đang làm

- **Cập nhật lần cuối:** 2026-07-26
- **Task:** T03 Notebook 03 - Làm sạch dữ liệu (data cleaning), theo `plans/nb03-data-cleaning-plan.md`
- **Nhánh:** `fix/thai-nb03-dtype-grouping` (nhánh mới, khác nhánh `feature/t03-data-cleaning` ghi ở các dòng cũ bên dưới — bản `feature/t03-data-cleaning` coi như lịch sử, không dùng lại)
- **Trạng thái:** đã hoàn thành lại toàn bộ NB03 trên nhánh này — **đã commit + push** (`dd50a22 "Update Notebook 03 data cleaning"`, khớp `origin/fix/thai-nb03-dtype-grouping`). Còn thiếu: tạo Pull Request.

## Làm tới đâu (cập nhật mới nhất ở trên)

- **2026-07-26:** Dựng lại toàn bộ `notebooks/03_data_cleaning.ipynb` từ đầu trên nhánh `fix/thai-nb03-dtype-grouping` (khác hẳn bản 2026-07-22/23 bên dưới — làm mới hoàn toàn qua nhiều lượt confirm với người dùng, viết nháp ở `03_data_cleaning2.ipynb` rồi người dùng tự đổi tên đè lên `03_data_cleaning.ipynb`).
  - Cấu trúc thật (126 cell: 89 markdown + 37 code): I. Giới thiệu → II. Đọc dữ liệu → III. Làm sạch dữ liệu (1. Missing Values, 2. Duplicate, 3. Outlier, 4. Xử lý dữ liệu sai logic, 5. Loại cột trùng lặp) → V. Đánh giá sau Data Cleaning → VI. Lưu dữ liệu → VII. Kết luận. **Lưu ý: đang thiếu số "IV"** (nhảy từ III sang V) — sinh ra từ lúc làm từng phần theo yêu cầu người dùng, chưa ai yêu cầu sửa lại số thứ tự nên vẫn để nguyên, nhóm trưởng xem có cần đổi không.
  - Input thật: `application_flat` qua `pd.read_sql` (307.511 dòng × 154 cột — khác 148 cột ghi ở bản cũ bên dưới, có thể do schema DB đã đổi giữa các lần). Missing Values xử lý theo nhóm (business-null flag `has_bureau/has_previous/has_installments/has_pos_cash/has_credit_card`, `own_car_age` giữ NaN, median-fill 46 cột số, `'Unknown'`-fill 5 cột chữ, drop dòng cho 9 cột missing rất ít). Outlier: IQR để phát hiện, capping **P99 chỉ chặn trên** (không chặn dưới, để không che lấp giá trị âm sai logic) cho 13 cột tiền tệ. Logic Validation: `bureau_sum_debt`/`credit_card_avg_balance` âm → clip 0; `days_employed=365243` (sentinel, trùng 100% với `organization_type='XNA'`) → NaN; `code_gender='XNA'` (4 dòng) → xoá dòng.
  - Loại cột trùng lặp (Mục III.5): 14 nhóm cột nhà/căn hộ có 3 biến thể `_avg`/`_mode`/`_medi` (tương quan 0,968–0,998) → giữ `_avg`, loại 28 cột `_mode`/`_medi` tương ứng; giữ nguyên 5 cột `_mode` không có cặp (`fondkapremont/housetype/totalarea/wallsmaterial/emergencystate_mode`).
  - Kết quả cuối: **305.181 dòng × 131 cột**, lưu vào PostgreSQL bảng `application_flat_cleaned` bằng `psycopg2` thuần (`execute_values`, không dùng SQLAlchemy/copy_expert) — đã đọc lại xác nhận khớp 100% shape và tổng Missing với `df` trong notebook. Toàn bộ notebook chạy `Run All` thật (không dùng nbconvert) qua script headless riêng, xác nhận 0 lỗi.
  - **Sự cố đáng nhớ khi lưu dữ liệu:** các script kiểm tra headless của tôi (Claude) không đóng kết nối `psycopg2` sau khi chạy xong, để lại session Postgres ở trạng thái "idle in transaction" — session này giữ lock trên bảng `application_flat_cleaned`, khiến lần lưu dữ liệu sau bị treo hơn 1 giờ ở lệnh `DROP TABLE`. Đã phát hiện qua `pg_stat_activity` và xử lý bằng `pg_terminate_backend()` (luôn xin xác nhận người dùng trước khi ngắt). Nếu gặp lại tình trạng lưu/đọc PostgreSQL bị treo bất thường trong notebook này, kiểm tra `pg_stat_activity` trước khi nghi code sai.
  - **Phạm vi commit đã chốt với người dùng:** `notebooks/01_data_understanding.ipynb` và `02_database_organization.ipynb` đang có thay đổi cục bộ không liên quan tới task này (NB02 còn dính lỗi gõ `'git5'` thay vì `'5'` trong 1 câu SQL) — đã xác nhận **không đưa 2 file này vào commit/PR**, chỉ push `03_data_cleaning.ipynb`. Có file khoá tạm `docs/~$sk Checklist for Each Notebook.docx` (Word tạo khi mở file) — không commit.
  - Còn thiếu so với bản 2026-07-22/23 bên dưới: chưa có mục "Đánh giá chất lượng ban đầu" riêng trước Missing Values (bản này gộp khảo sát vào Mục II).

- **2026-07-23:** Phát hiện bản "hoàn thành" ghi ngày 2026-07-22 bên dưới **không còn tồn tại** trong git lẫn working tree — 2 commit gần nhất (`0a6ac38`, `af707d6`) hoá ra chứa một khung sườn khác (làm sạch 8 bảng raw riêng rồi join lại trong NB03), trái với chính quyết định trong `plans/nb03-data-cleaning-plan.md` (chỉ làm sạch `application_flat`), và working tree còn bị rút gọn tiếp xuống còn 1 cell. Đã hỏi lại người dùng và được xác nhận dựng lại theo đúng `plans/nb03-data-cleaning-plan.md`.
  - Dựng lại toàn bộ `notebooks/03_data_cleaning.ipynb` từ `plans/nb03-data-cleaning-plan.md`: 45 cell (23 markdown + 22 code), 11 mục lớn (Giới thiệu → Đọc dữ liệu → Đánh giá chất lượng ban đầu → Missing → Duplicate → Outlier → Logic Validation → Loại cột trùng lặp → Đánh giá sau Cleaning → Lưu dữ liệu → Tổng kết), đúng thứ tự Outlier trước Logic Validation như file kế hoạch (không theo cách bản cũ đã mô tả là đảo ngược thứ tự).
  - Input thật: `application_flat` qua `pd.read_sql` (307.511 dòng x 148 cột). Output: `application_flat_cleaned` qua PostgreSQL bằng `psycopg2.copy_expert` (không dùng SQLAlchemy) — đã xác nhận trực tiếp trong PostgreSQL: đúng 307.511 dòng, 125 cột, `sk_id_curr` không trùng.
  - Kết quả: 125 cột sau cleaning (148 gốc + 5 cột cờ `has_<nhóm>` − 28 cột `_medi`/`_mode` trùng lặp). `Restart & Run All` bằng `nbconvert` sạch, execution_count liền mạch 1→22, không còn cảnh báo (đã sửa lỗi phát hiện cột chữ dùng `select_dtypes(include="object")` — pandas 3.0.3 đọc cột chữ mặc định về dtype `str` chứ không phải `object`, phải khai cả hai mới bắt đúng).
  - **Điểm tự quyết định vì file kế hoạch không nói rõ (cần nhóm trưởng duyệt lại):**
    1. Outlier: chỉ cap ngưỡng trên (P99), không cap ngưỡng dưới — tránh đúng vấn đề giá trị âm sai logic ở `bureau_sum_debt`/`credit_card_avg_balance` làm lệch ngưỡng phân vị dưới, mà không cần đổi thứ tự Mục so với file kế hoạch.
    2. `ext_source_1/2/3` (missing 19-56%): file kế hoạch chỉ nói "GIỮ cột", không nói rõ có điền hay không — đã áp dụng chung quy tắc "numeric còn missing → median" như các cột khác.
    3. `own_car_age` (missing 66%, trùng khớp 99,998% với `flag_own_car='N'`): giữ `NaN`, không điền — theo đúng phát hiện đã ghi nhận ở bản trước, nhưng đây không phải quyết định nằm trong Mục 5 của file kế hoạch, là suy luận thêm.
    4. Số cột chữ `_mode` (fondkapremont/housetype/wallsmaterial/emergencystate): thực tế đo được 4 cột, không phải 5 như ước lượng trong file kế hoạch — đã dùng số đo thật.
  - Chưa commit — đang chờ xác nhận.

- **2026-07-22 (lịch sử — nội dung notebook mô tả dưới đây đã KHÔNG còn trong repo, xem ghi chú 2026-07-23 ở trên):** Dựng lại hoàn toàn `notebooks/03_data_cleaning.ipynb` (repo đã reset trước đó, bản NB03/NB05 cũ ở dòng 2026-07-14 không còn áp dụng — không dùng lại làm nguồn tham khảo).
  - Input thật: `application_flat` đọc từ PostgreSQL bằng `pd.read_sql` (307.511 dòng x 148 cột), không đọc CSV.
  - 11 mục lớn đúng theo checklist thầy + kế hoạch nhóm trưởng: Missing Values (xử lý theo nhóm cột, giữ `NaN` + flag cho nhóm summary business-null thay vì bịa median), Duplicate, **Logic Validation trước Outlier** (đổi thứ tự so với sơ đồ tổng quát của thầy — lý do: nếu cap phân vị trước thì giá trị âm sai logic ở `bureau_sum_debt`/`credit_card_avg_balance` sẽ làm lệch ngưỡng phân vị), Outlier (cap phân vị 1-99%, không xoá dòng), loại 28 cột `_medi`/`_mode` trùng lặp, bảng so sánh Trước/Sau, lưu `application_flat_cleaned` về PostgreSQL bằng `psycopg2.copy_expert` (không dùng SQLAlchemy).
  - Kết quả: 126 cột sau cleaning (148 + 6 cột flag mới − 28 cột bỏ), 0 dòng mất, `Restart & Run All` sạch bằng `nbconvert`, execution_count liền mạch 1→31, đã xác nhận bảng `application_flat_cleaned` trong PostgreSQL đúng 307.511 dòng.
  - Phát hiện đáng chú ý: `own_car_age` missing 66% trùng khớp hoàn toàn với `flag_own_car='N'` — không cần tạo flag mới vì cột flag đã có sẵn.
  - **Lưu ý quan trọng phát hiện trong lúc làm:** checklist người dùng dán vào yêu cầu ban đầu (mục III-VI kiểu "khảo sát bảng chính/chất lượng/nhóm dữ liệu/bảng phụ") thực ra là checklist của **NB01**, không phải NB03 — đã hỏi lại và được xác nhận làm theo checklist NB03 thật (Missing/Duplicate/Outlier/Logic/Save).

## Còn dở / việc tiếp theo của tôi

- [x] Dựng và chạy thật `notebooks/03_data_cleaning.ipynb` trên PostgreSQL (bản 2026-07-26, nhánh `fix/thai-nb03-dtype-grouping`)
- [x] Lưu `application_flat_cleaned` (305.181 dòng × 131 cột) vào PostgreSQL, đã xác nhận khớp
- [x] Commit + push `notebooks/03_data_cleaning.ipynb` lên nhánh `fix/thai-nb03-dtype-grouping` (commit `dd50a22`, không kèm NB01/NB02)
- [ ] Commit + push file context này (`context/thai.md`)
- [ ] Tạo Pull Request, xin nhóm trưởng Hưng review — nhớ nhắc PR chỉ động vào NB03
- [ ] Hỏi nhóm trưởng: có cần đánh lại số mục (đang thiếu "IV", nhảy từ III sang V) không
- [ ] Xử lý riêng NB01/NB02 (lỗi `'git5'` ở NB02) ở task/nhánh khác, không gộp vào PR này

## Ghi chú riêng

- <lưu ý, thắc mắc cần hỏi nhóm trưởng, link tham khảo...>
