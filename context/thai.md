# Context cá nhân — Thái

> Chỉ mình Thái sửa file này. Cập nhật cuối mỗi buổi làm việc rồi commit ngay trong nhánh task của bạn.
> Nhớ khai báo tên đầu phiên: `echo thai > .claude/whoami`

## Đang làm

- **Task:** T03 Notebook 03 - Làm sạch dữ liệu (data cleaning), theo `plans/nb03-data-cleaning-plan.md`
- **Nhánh:** `feature/t03-data-cleaning`
- **Trạng thái:** đã hoàn thành, chờ commit/PR

## Làm tới đâu (cập nhật mới nhất ở trên)

- **2026-07-22:** Dựng lại hoàn toàn `notebooks/03_data_cleaning.ipynb` (repo đã reset trước đó, bản NB03/NB05 cũ ở dòng 2026-07-14 không còn áp dụng — không dùng lại làm nguồn tham khảo).
  - Input thật: `application_flat` đọc từ PostgreSQL bằng `pd.read_sql` (307.511 dòng x 148 cột), không đọc CSV.
  - 11 mục lớn đúng theo checklist thầy + kế hoạch nhóm trưởng: Missing Values (xử lý theo nhóm cột, giữ `NaN` + flag cho nhóm summary business-null thay vì bịa median), Duplicate, **Logic Validation trước Outlier** (đổi thứ tự so với sơ đồ tổng quát của thầy — lý do: nếu cap phân vị trước thì giá trị âm sai logic ở `bureau_sum_debt`/`credit_card_avg_balance` sẽ làm lệch ngưỡng phân vị), Outlier (cap phân vị 1-99%, không xoá dòng), loại 28 cột `_medi`/`_mode` trùng lặp, bảng so sánh Trước/Sau, lưu `application_flat_cleaned` về PostgreSQL bằng `psycopg2.copy_expert` (không dùng SQLAlchemy).
  - Kết quả: 126 cột sau cleaning (148 + 6 cột flag mới − 28 cột bỏ), 0 dòng mất, `Restart & Run All` sạch bằng `nbconvert`, execution_count liền mạch 1→31, đã xác nhận bảng `application_flat_cleaned` trong PostgreSQL đúng 307.511 dòng.
  - Phát hiện đáng chú ý: `own_car_age` missing 66% trùng khớp hoàn toàn với `flag_own_car='N'` — không cần tạo flag mới vì cột flag đã có sẵn.
  - **Lưu ý quan trọng phát hiện trong lúc làm:** checklist người dùng dán vào yêu cầu ban đầu (mục III-VI kiểu "khảo sát bảng chính/chất lượng/nhóm dữ liệu/bảng phụ") thực ra là checklist của **NB01**, không phải NB03 — đã hỏi lại và được xác nhận làm theo checklist NB03 thật (Missing/Duplicate/Outlier/Logic/Save).

## Còn dở / việc tiếp theo của tôi

- [x] Đọc `01_data_understanding.ipynb` và `02_database_organization.ipynb` để lấy coding style, không sửa nội dung hai file này
- [x] Dựng và chạy thật `notebooks/03_data_cleaning.ipynb` trên PostgreSQL
- [ ] Commit trong nhánh `feature/t03-data-cleaning` (chưa commit — đang chờ xác nhận)
- [ ] Đẩy code lên GitHub và tạo Pull Request (chờ nhóm trưởng Hưng review và merge)

## Ghi chú riêng

- <lưu ý, thắc mắc cần hỏi nhóm trưởng, link tham khảo...>
