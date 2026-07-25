# Context cá nhân — Huy

> Chỉ mình Huy sửa file này. Cập nhật cuối mỗi buổi làm việc rồi commit ngay trong nhánh task của bạn.
> Nhớ khai báo tên đầu phiên: `echo huy > .claude/whoami`

## Đang làm

- **Task:** Sửa lỗi hiển thị số khoa học (scientific notation) trong Notebook 01 & T09 Notebook 04
- **Nhánh:** `fix/nb01-scientific-notation`
- **Trạng thái:** Đang triển khai sửa lỗi hiển thị và chạy lại Notebook 01

## Làm tới đâu (cập nhật mới nhất ở trên)

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

- [ ] Tạo nhánh mới `feature/t09-eda-visualization` và commit file notebook 04 cùng các thay đổi lên GitHub.
- [ ] Tạo PR cho task T09 gửi nhóm trưởng Hưng duyệt.

## Ghi chú riêng

- Các biểu đồ đều tuân thủ định dạng của nhóm (Title, Label, Legend) và có cell Markdown nhận xét ngay bên dưới.
- Không load trực tiếp file CSV 2.5GB vào Pandas mà sử dụng SQL qua PostgreSQL để lấy mẫu nhanh gọn.


