# Context cá nhân — Huy

> Chỉ mình Huy sửa file này. Cập nhật cuối mỗi buổi làm việc rồi commit ngay trong nhánh task của bạn.
> Nhớ khai báo tên đầu phiên: `echo huy > .claude/whoami`

## Đang làm

- **Task:** T09 Notebook 04 - EDA & trực quan hóa
- **Nhánh:** `feature/t09-eda-visualization`
- **Trạng thái:** Xong (Đã hoàn thành phân tích và vẽ biểu đồ, thực thi notebook thành công)

## Làm tới đâu (cập nhật mới nhất ở trên)

- **2026-07-31 (Su dung 100% du lieu, doc hoa & chi tiet hoa nhan):**
  - Cau hinh notebook 04 (`USE_FULL_DATA = True`) de thuc hien EDA tren toan bo 307.511 dong du lieu.
  - Chuyển 3 biểu đồ phân phối tài chính ở Cell [19] sang chiều dọc giúp phóng to biểu đồ theo chiều ngang, tránh đè nhãn số.
  - Viết code Python tự động tính toán các phân vị thực tế của thu nhập/khoản vay, quy đổi sang triệu VND và chèn trực tiếp dưới nhãn 'Rất thấp', 'Thấp'... ở Cell [23].
  - Định dạng lại các nhãn Q1-Q5 ở biểu đồ DTI và LTV (Cell [26]) để hiển thị khoảng giá trị tỷ lệ phần trăm % thực tế cụ thể.
  - Chay nbconvert thuc thi thanh cong, cap nhat toan bo bieu do voi full dataset va nhan song ngu, dinh dang so.

- **2026-07-30 (Hop nhat, them bieu do va day code Notebook 04):**
  - Tao nhanh moi `feature/t09-eda-visualization-30-07-2026` tu `main` moi nhat.
  - Hop nhat file notebook 04 hoan chinh tu thu muc `D:\hoc` vao repository.
  - Bo sung bieu do cot bieu dien he so tuong quan Pearson ngang voi TARGET sap xep giam dan theo tri tuyet doi.
  - Chay nbconvert thuc thi thanh cong 100% va cap nhat file.

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
  - Hoàn thiện toàn bộ notebook [04_eda_visualization.ipynb](file:///d:/du%20an%201/notebooks/04_eda_visualization.ipynb) với đầy đủ các phân tích đơn biến, đa biến, phân tích tương quan từ các bảng phụ (`bureau`, `installments_payments`) và ma trận tương quan Heatmap.
  - Sử dụng SQL kết nối trực tiếp đến PostgreSQL cục bộ để truy vấn lấy mẫu ngẫu nhiên (50,000 dòng) giúp tối ưu hóa bộ nhớ và hiệu năng vẽ biểu đồ.
  - Chạy thực nghiệm thành công toàn bộ notebook, xuất và nhúng đầy đủ tất cả biểu đồ trực quan hóa.
  - Rút ra các phát hiện nghiệp vụ quan trọng (Insights) định hướng cho Feature Engineering.

## Còn dở / việc tiếp theo của tôi

- [x] Tạo nhánh mới và commit file notebook 04 cùng các thay đổi lên GitHub.
- [ ] Tạo PR cho task T09 gửi nhóm trưởng Hưng duyệt.

## Ghi chú riêng

- Các biểu đồ đều tuân thủ định dạng của nhóm (Title, Label, Legend) và có cell Markdown nhận xét ngay bên dưới.
- Dữ liệu nạp từ CSDL PostgreSQL local thông qua nạp file cấu hình cục bộ, sử dụng mẫu phân tầng 50.000 dòng rất mượt mà.
