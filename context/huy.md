# Context cá nhân — Huy

> Chỉ mình Huy sửa file này. Cập nhật cuối mỗi buổi làm việc rồi commit ngay trong nhánh task của bạn.
> Nhớ khai báo tên đầu phiên: `echo huy > .claude/whoami`

## Đang làm

- **Task:** Hoàn thành Notebook 04 (EDA & Visualization) & Hỗ trợ chuẩn hóa dữ liệu Notebook 03
- **Nhánh:** `fix/nb01-scientific-notation` (hoặc nhánh làm việc hiện tại)
- **Trạng thái:** Đã hoàn thành 100% việc chạy database organization, data cleaning (Notebook 03) và chạy kiểm thử thành công Notebook 04. Đã sẵn sàng bàn giao sang Notebook 05.

## Làm tới đâu (cập nhật mới nhất ở trên)

- **2026-07-28 (Hoàn thành Notebook 04 & Pipeline dữ liệu):**
  - Chạy thành công các SQL script (`sql/05`, `sql/06`, `sql/08`) để tạo index, các bảng summary và bảng phẳng `application_flat` (gồm 307.511 dòng).
  - Khắc phục lỗi nạp file `.env` khi chạy Jupyter kernel bằng cách sao chép file `.env` vào thư mục `notebooks/.env`.
  - Thực thi tự động Notebook 03 (`03_data_cleaning.ipynb`) qua `nbconvert` thành công để sinh bảng phẳng đã làm sạch `application_flat_cleaned` với đầy đủ 307.511 dòng.
  - Viết code và nhận xét nghiệp vụ chi tiết cho toàn bộ các phần trong Notebook 04 (`04_eda_visualization.ipynb`), bao gồm: Đọc dữ liệu, Stratified Sampling (50.000 dòng), Phân tích đơn biến, Phân tích đa biến/tương quan nợ xấu, và bảng bàn giao 10 biến phái sinh đề xuất sang Notebook 05.
  - Chạy `nbconvert` kiểm thử thành công 100% không lỗi cho Notebook 04.

- **2026-07-25 (Sửa hiển thị số khoa học trong NB01):**
  - Tạo nhánh `fix/nb01-scientific-notation` từ `main` sau khi pull code mới nhất.
  - Sửa file `notebooks/01_data_understanding.ipynb` để thêm cấu hình `pd.options.display.float_format = '{:.2f}'.format` trong Cell 1.
  - Đang chạy lại notebook bằng `nbconvert` để cập nhật hiển thị các số lớn/nhỏ trong thống kê mô tả (describe) thành số cụ thể thay vì dạng mũ khoa học (như `1.17e+08` -> `117000000.00`).

- **2026-07-13:**
  - Khai báo danh tính `huy`, chuyển hướng sang thực hiện task T09.
  - Cài đặt thư viện `nbconvert` và `ipykernel` phục vụ chạy tự động notebook.
  - Hoàn thiện toàn bộ notebook [04_eda_visualization.ipynb](file:///d:/du an 1/notebooks/04_eda_visualization.ipynb) với đầy đủ các phân tích đơn biến, đa biến, phân tích tương quan từ các bảng phụ (`bureau`, `installments_payments`) và ma trận tương quan Heatmap.
  - Sử dụng SQL kết nối trực tiếp đến PostgreSQL cục bộ để truy vấn lấy mẫu ngẫu nhiên (50,000 dòng) giúp tối ưu hóa bộ nhớ và hiệu năng vẽ biểu đồ.
  - Chạy thực nghiệm thành công toàn bộ notebook, xuất và nhúng đầy đủ tất cả biểu đồ trực quan hóa.
  - Rút ra các phát hiện nghiệp vụ quan trọng (Insights) định hướng cho Feature Engineering.

## Còn dở / việc tiếp theo của tôi

- [ ] Tạo nhánh mới và commit file notebook 04 cùng các thay đổi lên GitHub.
- [ ] Tạo PR cho task T09 gửi nhóm trưởng Hưng duyệt.

## Ghi chú riêng

- Các biểu đồ đều tuân thủ định dạng của nhóm (Title, Label, Legend) và có cell Markdown nhận xét ngay bên dưới.
- Dữ liệu nạp từ CSDL PostgreSQL local thông qua nạp file cấu hình cục bộ, sử dụng mẫu phân tầng 50.000 dòng rất mượt mà.
