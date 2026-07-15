# Context cá nhân — Thắng

> Chỉ mình Thắng sửa file này. Cập nhật cuối mỗi buổi làm việc rồi commit ngay trong nhánh task của bạn.
> Nhớ khai báo tên đầu phiên: `echo thang > .claude/whoami`

## Đang làm

- **Task:** T11 Notebook 06 - Huấn luyện & đánh giá model
- **Nhánh:** `feature/t11-notebook-06-modeling`
- **Trạng thái:** Hoàn thành (Đang gửi PR)

## Làm tới đâu (cập nhật mới nhất ở trên)

- **2026-07-15:** Hoàn thành T11 — notebook `06_machine_learnig.ipynb` (34 cell, 12 cell code), đã Restart & Run All trên **toàn bộ 307.511 dòng** (`DEBUG = False`, execution_count liền mạch 1→12, 3 biểu đồ nhúng thật).
  - **Kết quả mốc nền:** so sánh 4 mô hình trên 61.503 dòng kiểm định — **HistGradientBoosting thắng, AUC-ROC = 0,7792**; Logistic Regression 0,7691; Random Forest 0,7630; Dummy 0,5000. Chỉ dùng scikit-learn, **không cài thêm LightGBM/XGBoost**.
  - **Đã gỡ nút thắt:** `models/model.pkl` (trước là file rỗng 0 byte) nay là model thật 1,0 MB → Thái (T14), Huy (T13/T15) và báo cáo Chương 4 hết bị chặn.
  - **Thêm `models/model_metadata.json`** (thứ tự 297 cột + ngưỡng + AUC) và xin Hưng cho ngoại lệ `.gitignore` để file 10KB này lên được GitHub — app không phải chạy lại NB06 chỉ để biết thứ tự cột.
  - **Ngưỡng quyết định:** ngưỡng mặc định 0,5 của sklearn **chỉ bắt được 3,24% khách vỡ nợ** → notebook chốt ngưỡng Youden J = 0,0747 (bắt 73%, nhưng từ chối oan 17.398 khách tốt). Ai làm app nhớ đọc `decision_threshold` từ metadata, **đừng dùng `.predict()` mặc định**.
  - **Phát hiện đáng chú ý:** `EXT_SOURCES_MEAN` (biến phái sinh của NB05) quan trọng **gấp 13 lần** biến kế tiếp; 3/7 đặc trưng mạnh nhất đào từ bảng phụ (installments, POS_CASH) → bằng chứng cho Phần B đề bài. Khoảng cách 3 mô hình rất hẹp (~0,016) ⇒ **T24 nên đầu tư thêm đặc trưng hơn là đổi thuật toán**.
  - **Suýt dính lại bẫy cũ của nhóm:** bản nháp markdown ghi sẵn "EXT_SOURCE_1/2/3 đứng đầu" nhưng số liệu chạy thật lại khác hẳn → đã sửa toàn bộ nhận xét theo output thật. Nhắc lại: `nbconvert` chỉ cập nhật output, **KHÔNG đụng markdown**.
- **2026-07-13:** Hoàn thành xây dựng notebook `05_feature_engineering.ipynb` theo đúng Quy ước định dạng notebook của nhóm. Triển khai kỹ thuật đọc dữ liệu theo chunk để tránh lỗi tràn RAM (OOM) do bộ dữ liệu Home Credit quá lớn (~2.5GB). Đã tổng hợp thành công các đặc trưng nghiệp vụ từ 5 bảng phụ:
  - `bureau` & `bureau_balance` (số lượng khoản vay ngoài, số khoản vay active, tổng dư nợ nợ ngoài, tỷ lệ nợ nợ/hạn mức trung bình, v.v.)
  - `previous_application` (tỷ lệ duyệt hồ sơ cũ, tỷ lệ số tiền duyệt/đăng ký trung bình, v.v.)
  - `installments_payments` (tần suất trễ hạn, đóng thiếu, số ngày trễ tối đa, v.v.)
  - `POS_CASH_balance` (số ngày quá hạn tối đa POS, số tháng quá hạn POS, v.v.)
  - `credit_card_balance` (tỷ lệ sử dụng thẻ trung bình, dư nợ thẻ trung bình, v.v.)
  Đồng thời thiết lập các biến tương tác tài chính nghiệp vụ (DTI, Payment rate...), mã hóa One-Hot, chuẩn hóa StandardScaler và xuất dữ liệu sạch ra `data/processed/train_features.csv` và `data/processed/test_features.csv`, lưu đối tượng chuẩn hóa vào `models/scaler.pkl`. Đã chạy toàn bộ notebook ở chế độ DEBUG mẫu (20,000 dòng) thành công và lưu output thật vào notebook.
- **2026-07-13:** Nhận task T07, tạo nhánh `feature/t07-sql-indexes` từ `main` mới nhất. Rà soát file `sql/05_indexes.sql` hiện có và lập kế hoạch tối ưu chỉ mục cho các bảng.
- **2026-07-03:** Hoàn thành thiết kế schema PostgreSQL cho 8 bảng dữ liệu thô. Viết mã script SQL đầy đủ và tối ưu kiểu dữ liệu tại [01_create_tables.sql](file:///d:/FPT%20Polytechnic%202026/HK%20Summer%202026/Block2/Du-an-01/credit-risk-classifier/sql/01_create_tables.sql). Rà soát kỹ lưỡng cú pháp và định dạng. Sẵn sàng tạo Pull Request.
- **2026-07-03:** Khai báo danh tính `thang`, pull code mới nhất trên main và switch sang nhánh `feature/t02-sql-create-tables`. Bắt đầu nghiên cứu cấu trúc dữ liệu và lập kế hoạch tạo bảng SQL.

## Còn dở / việc tiếp theo của tôi

- [x] **T11:** train mốc nền trên 299 cột hiện có, so sánh nhiều mô hình, chấm bằng AUC-ROC, xuất `models/model.pkl`.
- [ ] **T11:** chờ Hưng review + merge PR nhánh `feature/t11-notebook-06-modeling`.
- [ ] **T24 (sau này):** tối ưu mô hình — lấy **AUC 0,7792 làm mốc nền để so sánh**. Hướng đáng thử theo thứ tự: (1) thêm/tinh chỉnh đặc trưng (vì 3 mô hình chỉ chênh ~0,016 ⇒ thuật toán không phải nút thắt), (2) tinh chỉnh siêu tham số HistGradientBoosting, (3) cross-validation thay holdout, (4) thử SMOTE.
- [x] Xây dựng notebook 05: đọc dữ liệu từ `data/raw/`, làm sạch tối thiểu, tổng hợp đặc trưng từ bảng phụ (bureau, previous_application, installments_payments, credit_card_balance, POS_CASH_balance), tạo biến mới, mã hóa/scale.
- [x] Xuất bảng đặc trưng hoàn chỉnh ra `data/processed/`.
- [x] Chạy toàn bộ notebook để nhúng output thật, sau đó `git pull --rebase origin main` rồi push + tạo PR.
- [ ] Chờ nhóm trưởng review và merge PR nhánh `feature/t10-feature-engineering`.

## Ghi chú riêng

- Xem cấu trúc bảng trong tài liệu `01_data_understanding.ipynb` hoặc mô tả cột trong Kaggle dataset.
