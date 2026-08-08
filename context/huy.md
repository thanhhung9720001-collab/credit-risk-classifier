# Context cá nhân — Huy

> Chỉ mình Huy sửa file này. Cập nhật cuối mỗi buổi làm việc rồi commit ngay trong nhánh task của bạn.
> Nhớ khai báo tên đầu phiên: `echo huy > .claude/whoami`

## Đang làm

- **Task:** T11 Notebook 06 - Machine Learning
- **Nhánh:** `feature/t11-huy-modeling`
- **Trạng thái:** NB06 hoàn chỉnh toàn bộ 9 mục, chạy sạch 46/46 cell, chờ tạo PR

## Làm tới đâu (cập nhật mới nhất ở trên)

- **2026-08-09 (Hoàn thiện NB06: viết nốt Mục VII.3 → IX, đổi cách dò ngưỡng, dọn số liệu cũ):**
  - **Đổi cách chia tập còn Train/Test (bỏ Validation)** theo thống nhất của nhóm. Kéo theo việc ngưỡng quyết định không còn chỗ dò sạch, nên chuyển sang **dò bằng cross-validation 5 phần trong tập Train** (xác suất out-of-fold) — tập Test chỉ chạm đúng một lần ở Mục VIII.3.
  - **Mục VII.3** — thêm phần kiểm tra học vẹt (so điểm Train với điểm Test) và bảng 4 tiêu chí chọn mô hình. Phát hiện Random Forest học vẹt nặng (chênh 0,0776 ROC-AUC), giải thích được vì sao nó thua cả Logistic Regression trên Test.
  - **Mục VII.4** — đo đóng góp của 30 feature NB05 tạo ra bằng ablation (11 lần huấn luyện lại). Kết quả ngược kỳ vọng: chúng chiếm 50,6% độ quan trọng nhưng bỏ hết chỉ mất 0,0031 ROC-AUC, vì phần lớn là biến phái sinh từ cột gốc vẫn còn trong dữ liệu. Chỉ nhóm Tỷ số tài chính là mất điểm thật.
  - **Mục VIII.1 → VIII.5** — chốt HistGradientBoosting (kèm bảng ba điểm yếu phải chấp nhận), dò ngưỡng 0,4730, chấm cuối trên Test (ROC-AUC 0,7749 / PR-AUC 0,2636 / Recall 0,7138), lưu 3 file bàn giao và viết phiếu bàn giao cho NB07. Kiểm chứng đọc lại file từ đĩa cho ra đúng từng con số, sai lệch 0,00e+00.
  - **Mục IX** — viết Tổng kết, có nêu rõ hạn chế (ba mô hình được so trên chính tập Test ở Mục VII; Accuracy 0,70 thấp hơn mức đoán bừa là cố ý; phép kiểm chứng chưa phủ hai bước đầu của pipeline).
  - **Dọn 8 chỗ trong code và 20 nhận xét** còn giữ số của bản chia 3 tệp: ô trống Train 1.602.984 → 2.142.589, Maternity leave 2 khách/183.108 dòng → 4 khách/244.144 dòng, RF mỗi cây 764 → 896 nhóm, HGB dừng ở cây 184 → 219... Thay các con số hard-code (`319 cột`, `183 cột`, `61.036 khách`) bằng biến tính từ dữ liệu để lần sau đổi cách chia tập thì nhãn tự đúng.
  - Bỏ hết số giây cụ thể trong nhận xét (đổi thành "chưa tới 10 giây", "gấp khoảng 4 lần") vì thời gian huấn luyện đổi theo từng lần chạy máy.
  - Notebook từ 91 lên **174 cell**, chạy `nbconvert --execute` sạch **46/46 cell**, `execution_count` liền mạch.

- **2026-08-07 (Rà soát lại NB06, tách tập Validation và vá lỗ hổng bàn giao):**
  - Rà soát lại toàn bộ 82 cell của NB06 sau lần chạy đầu, phát hiện 6 nhóm vấn đề.
  - **Sửa lỗi đường dẫn:** notebook lưu artifact vào `notebooks/models/` thay vì `models/` ở gốc repo (do cwd của kernel là `notebooks/`). Thêm biến `PROJECT_ROOT` / `MODELS_DIR` dò theo vị trí `AGENTS.md`.
  - **Tách tập Validation:** chia lại Train/Validation/Test = 60/20/20 có phân tầng. Trước đó ngưỡng Youden's J được dò trên chính tập Test rồi báo cáo cũng trên Test, làm chỉ số lạc quan hơn thực tế. Nay chọn mô hình + ngưỡng trên Validation, tập Test chỉ chạm đúng một lần ở Mục VIII.3 mới thêm.
  - **Bổ sung PR-AUC** cho cả 3 mô hình và bảng so sánh; thêm Mục VII.2 vẽ đường cong ROC và Precision-Recall của 3 mô hình.
  - **Vá lỗ hổng bàn giao NB07:** trước đó chỉ lưu `scaler.pkl`, thiếu imputer và encoder nên NB07 không thể dựng lại đúng 318 cột từ hồ sơ thô. Nay lưu `preprocessor.pkl` gồm trọn bộ num_imputer, cat_imputer, encoder, scaler kèm danh sách cột và thứ tự đặc trưng. Đã kiểm chứng load lại và dự đoán được end-to-end.
  - **Viết lại toàn bộ 26 cell nhận xét** theo số liệu thực tế — bản cũ còn ghi số của lần chạy trước (ROC-AUC 0.7792, ngưỡng 0.0747) không khớp output ngay bên trên.
  - Kết quả cuối: HistGradientBoosting, ROC-AUC **0.7716** / PR-AUC **0.2609** trên tập Test, ngưỡng 0.4923, Recall nợ xấu 69%. Test cao hơn Validation (0.7658) nên mô hình không quá khớp.
  - Notebook từ 82 lên 91 cell, chạy `nbconvert --execute` sạch 25/25 cell, `execution_count` liền mạch.

- **2026-08-07 (Triển khai mô hình học máy và đánh giá NB06 — bản đầu, đã được rà soát lại ở trên):**
  - Tạo nhánh `feature/t11-huy-modeling` từ `main`.
  - Cập nhật tiêu đề Mục VI thành "Mô hình HistGradientBoosting" và chọn phương án sử dụng `HistGradientBoostingClassifier` của scikit-learn thay thế XGBoost theo thống nhất của nhóm để tránh phát sinh dependency ngoài.
  - Triển khai chia tập Train/Test theo tỉ lệ 80/20 có phân tầng (`stratify=y`) dựa trên biến mục tiêu `target`.
  - Triển khai xử lý khuyết thiếu (SimpleImputer), mã hóa One-Hot (OneHotEncoder) và chuẩn hóa dữ liệu (StandardScaler) tuân thủ chặt chẽ nguyên tắc không rò rỉ dữ liệu (chỉ fit trên tập Train, transform trên cả 2 tập).
  - Huấn luyện và đánh giá chi tiết 3 mô hình: Logistic Regression (`class_weight='balanced'`), Random Forest (`class_weight='balanced'`), và HistGradientBoostingClassifier (sử dụng trọng số dòng huấn luyện tương đương).
  - Vẽ biểu đồ Top 15 đặc trưng quan trọng nhất (Feature Importance) cho Random Forest và HistGradientBoosting (sử dụng Permutation Importance trên tập validation mẫu 5.000 dòng).
  - Đối chiếu hiệu năng đa chỉ số (ROC-AUC, PR-AUC, F1, Precision, Recall) và lập bảng so sánh kết quả.
  - Tối ưu hóa ngưỡng quyết định (Decision Threshold) dựa trên Youden's J statistic đạt giá trị tối ưu (~0.0747), cải thiện Recall nhóm nợ xấu lên ~73% để đáp ứng yêu cầu nghiệp vụ tín dụng.
  - Lưu scaler vào `models/scaler.pkl`, lưu mô hình tốt nhất vào `models/model.pkl`, và lưu cấu hình metadata bàn giao vào `models/model_metadata.json`.
  - Chạy `nbconvert` thực thi lại toàn bộ notebook kiểm thử.


- **2026-08-02 (Don dep warning, bo sung 9 phan tich moi, chuan hoa dinh dang):**
  - Chay lai Notebook 04 voi Claude Code, don sach toan bo warning khi chay (seaborn `palette` thieu `hue`, `ci` deprecated, `set_xticklabels` thieu `set_xticks`).
  - Gop 2 bieu do phan bo thu nhap (du lieu goc co outlier / da loc <=500tr) thanh 1 cell so sanh TRUOC/SAU, bo sung bieu do quy mo gia dinh (`cnt_fam_members`) con thieu o muc 1.
  - Phat hien va sua nhieu nhan xet cu KHONG khop so lieu chay tren full data (vi du: ty le vo no theo thu nhap/khoan vay khong giam/tang don dieu nhu mo ta cu; `has_cc_dpd` gan nhu khong co tin hieu khi loc dung nhom co the).
  - Bo sung 9 phan tich EDA moi theo de xuat rieng: `INCOME_PER_PERSON`, heatmap ket hop DTI x LTV, so huu xe/BDS, loai hop dong vay, `region_rating_client`, `years_employed` (phat hien artifact tu buoc impute median o NB03 cho ma loi `DAYS_EMPLOYED=365243`), `bureau_count`, lich su bi tu choi don vay truoc (`previous_application`, query truc tiep SQL), ty le su dung han muc the tin dung.
  - Mo rong bieu do tuong quan Pearson len Top 30 bien (thay vi 11 bien chon thu cong), heatmap rieng con Top 10 bien cho de doc.
  - Tai cau truc toan bo notebook theo yeu cau moi: gach dau dong het cac nhan xet nhieu y, tach cac cell dai (co cell 55 dong gop 4 bieu do) thanh cell nho moi cell 1 viec, bo sung trich dan nguon (NB nao) cho cac insight quan trong. Notebook tu 80 cell len 102 cell.
  - Xu ly 1 xung dot rebase voi commit "fix: hung fix NB04" cua Hung tren main (ca 2 doc lap sua cung vung gom import/bieu do thu nhap) - da doi chieu tung cell va gop giu ca 2 phan cai tien.
  - Da chay `nbconvert --execute` xac nhan 0 loi sau moi buoc, commit va push (`--force-with-lease` do nhanh da rebase).

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
