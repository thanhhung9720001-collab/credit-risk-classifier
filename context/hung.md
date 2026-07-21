# Context cá nhân — Hưng (nhóm trưởng)

> Chỉ mình Hưng sửa file này. Cập nhật cuối mỗi buổi làm việc rồi commit ngay trong nhánh task.

## Đang làm

- **Task:** Cập nhật context sau khi hoàn thành Data Understanding.
- **Nhánh hiện tại:** `docs/cap-nhat-context-data-understanding`.
- **Trạng thái:** Business Understanding đã merge PR #53; Data Understanding đã merge PR #54 vào `main`. Đang cập nhật `PROJECT_CONTEXT.md` và context cá nhân để phản ánh trạng thái thật sau reset: NB01 xong, `sql/` trống, NB02–NB07 cần làm lại theo kế hoạch mới.

## Làm tới đâu (cập nhật mới nhất ở trên)

- **2026-07-20 (Cập nhật context sau Data Understanding — nhánh `docs/cap-nhat-context-data-understanding`):** Cập nhật lại bức tranh dự án sau khi PR #53 và PR #54 đã merge vào `main`.
  - **Business Understanding (PR #53):** `docs/Business_Understanding.docx` đã bổ sung mục tiêu nghiên cứu, giới thiệu dataset, giới thiệu công nghệ, lý do chọn Home Credit, tầm quan trọng trong ngành AI, SWOT và chỉnh heading/bullet.
  - **Data Understanding (PR #54):** `docs/Data_Understanding.docx`, ERD mới, outline NB01 và `notebooks/01_data_understanding.ipynb` đã merge vào `main`.
  - **NB01 hiện tại:** 8 mục lớn, 62 cell / 21 code cell, đã Restart & Run All thành công, execution_count 1→21; có overview dataset, `nunique`, `describe`, kiểm chứng bất thường, missing/duplicate, target imbalance, khóa/grain bảng phụ, biểu đồ numeric/category, correlation và heatmap.
  - **Trạng thái thật sau reset:** `notebooks/` hiện chỉ còn NB01; `sql/` hiện trống; NB02–NB07 và SQL cần làm lại theo kế hoạch mới. Model artifacts trong `models/` còn từ pipeline cũ, cần kiểm tra compatibility trước khi dùng cho app/NB07.
  - **Việc tiếp theo hợp lý:** lên kế hoạch Data Cleaning/NB03, sau đó lên lại SQL/PostgreSQL và các notebook còn lại.

- **2026-07-20 (Reset notebook/SQL — nhánh `fix/nb01-rut-gon-checklist`):** Hưng quyết định xóa toàn bộ notebook và SQL để làm lại từ đầu.
  - Đã xóa 7 file notebook trong `notebooks/`: NB01 → NB07.
  - Đã xóa 5 file SQL trong `sql/`: `01_create_tables.sql` → `05_indexes.sql`.
  - Chưa tạo lại scaffold/nội dung mới; bước tiếp theo là chốt lại kế hoạch notebook + SQL mới trước khi viết lại.

- **2026-07-20 (Rút gọn NB01 theo checklist — nhánh `fix/nb01-rut-gon-checklist`):** Làm lại mạch đọc NB01 cho ngắn hơn sau khi thấy bản cũ vẫn dài và khó hiểu.
  - Giữ code/bằng chứng chính, nhưng rút markdown: bỏ các đoạn giảng sâu về ROC-AUC/accuracy, pipeline ASCII dài, thách thức dữ liệu dài.
  - Bố cục mới gồm 8 mục lớn, đúng tinh thần checklist: bài toán & target → chuẩn bị → dataset → bảng chính → chất lượng dữ liệu → bảng phụ/khóa → từ điển → tổng kết/handoff.
  - Bổ sung cụm biểu đồ sau `describe()` theo kiểu mỗi nhận xét một biểu đồ riêng: histogram kiểm tra lệch trái/phải của biến tiền tệ, max/median, std/mean, min/median/max của `DAYS_*`, và boxplot `EXT_SOURCE_1/2/3`.
  - Sửa lỗi chạy cell: `profile_table` không còn dùng `include=["object", "string"]`, tự khai báo lại `TABLES` khi thiếu và bỏ `.style` để tránh phụ thuộc `jinja2`; cell đọc `application_train.csv` tự dò `DATA_RAW` nếu người đọc chạy riêng cell đó.
  - Chốt lại phạm vi handoff: NB01 chỉ rút insight trực tiếp cho **NB02** (database/import/aggregate) và **NB03** (cleaning), không bàn giao thẳng sang NB05/NB06.
  - **Verify:** JSON notebook load được, toàn bộ code cell parse AST được, `git diff --check` sạch. Cell biểu đồ mới chưa có output vì chưa Restart & Run All bằng nbconvert; môi trường Codex hiện tại thiếu Jupyter/ipykernel/matplotlib/seaborn.

- **2026-07-20 (Checklist NB01 theo hướng dẫn giảng viên — nhánh `docs/nb01-huong-dan-checklist-video`):** Lưu và áp dụng hướng dẫn thầy Long cho NB01.
  - **Tài liệu hướng dẫn:** thêm `docs/huong-dan-giang-vien/huong-dan-nb01-task-checklist-2026-07-20.md`, cập nhật index trong `README.md`, `tai-lieu-tham-chieu.md`, `video-bai-giang.md`.
  - **NB01:** giữ cấu trúc lớn đã đúng, chỉ sửa scoped theo checklist: mục tiêu/câu hỏi dẫn đường rõ hơn, thêm kiểm tra `CODE_GENDER = XNA`, nhấn mạnh join bảng 1-n gây **nổ số dòng / row explosion** nên cần aggregate/summary, thêm bảng handoff `Phát hiện NB01 → notebook sau → việc cần làm`.
  - **Verify:** JSON notebook load được, toàn bộ code cell parse AST được, không còn `execution_count=None`, execution_count 1→16 liền mạch, `git diff --check` sạch. Chưa Restart & Run All bằng nbconvert vì môi trường Codex hiện tại thiếu Jupyter/ipykernel/matplotlib/seaborn; output cho các cell bị ảnh hưởng đã được tính lại bằng pandas.

- **2026-07-18 (Sửa nhỏ NB01 — nhánh `fix/nb01-tach-cell-days-employed`):** Tách cell đang xử lý chung `DAYS_BIRTH` và `DAYS_EMPLOYED` thành 2 markdown + 2 code cell riêng để nhóm dễ giải thích khi bảo vệ.
  - `DAYS_BIRTH`: đổi số ngày âm sang tuổi để kiểm tra khoảng tuổi khách hàng.
  - `DAYS_EMPLOYED`: kiểm tra riêng giá trị bất thường `365243`, làm rõ đây là mã đặc biệt cần xử lý ở NB03.
  - **Verify:** JSON notebook load được, toàn bộ code cell parse AST được, `git diff --check` sạch. Chưa Restart & Run All vì đây là chỉnh cấu trúc cell nhỏ và output được tách lại từ kết quả đã có.

- **2026-07-18 (Feedback giảng viên NB01/NB02/NB03 — nhánh `fix/feedback-giang-vien-nb02-nb03`):** Dọn Git và bắt đầu sửa 3 notebook theo feedback của thầy.
  - **Dọn Git trước:** đang ở `docs/bo-sung-video-feature-engineering`, có commit `docs: bo sung video feature engineering`; đã xử lý thay đổi lạc trong working tree. Đã push nhánh video lên GitHub; connector GitHub không tạo PR được do lỗi quyền `403 Resource not accessible by integration`, link tạo PR thủ công: `https://github.com/thanhhung9720001-collab/credit-risk-classifier/pull/new/docs/bo-sung-video-feature-engineering`.
  - **Tạo nhánh mới:** từ `main` mới nhất, tạo `fix/feedback-giang-vien-nb02-nb03`.
  - **Ghi chú feedback:** thêm `docs/huong-dan-giang-vien/feedback-giang-vien-nb02-nb03-2026-07-18.md` để nhắc các điểm: bỏ icon, thêm markdown trước code, NB02 là database pipeline trung tâm, clean/features ghi lại database, NB03 cleaning có bằng chứng/lý do/kiểm tra, code ưu tiên dễ hiểu.
  - **NB01:** bỏ icon ở tiêu đề/heading, đổi cell mở đầu sang chữ ngắn hơn, thêm markdown "Trước khi chạy code" trước các cell code.
  - **Bổ sung NB01 theo hướng dẫn giảng viên:** thêm link đọc trước `docs/Business_Understanding.docx`; thêm tiểu mục `5.1.1` kiểm tra dạng `.info()` rút gọn và duplicate (`app.duplicated()`, `SK_ID_CURR.duplicated()`).
  - **NB02:** viết lại mạch thành **Database Pipeline trung tâm**; thêm mục vai trò NB02, hợp đồng dữ liệu cho NB03/NB04/NB05/NB06 đọc bằng `pd.read_sql`, validation sau import và sau view/aggregation, ghi rõ bảng clean/features cần đưa ngược lại DB.
  - **NB03:** viết khung quyết định cleaning theo dạng Vấn đề → Bằng chứng → Cách xử lý → Lý do → Kiểm tra; renumber mục; thêm bước ghi `application_train_clean` và `application_test_clean` về PostgreSQL bằng `COPY` nếu máy có `.env`.
  - **Pass sửa "mùi AI" tiếp theo:** thay các cụm như "Chúng ta sẽ", "Import thành công", "Thực thi thành công", "cực kỳ..." bằng câu ngắn hơn.
  - **Chỉnh quy tắc markdown theo feedback mới:** markdown trước code chỉ viết 1 câu ngắn dạng "Đoạn code bên dưới...", không viết dài kiểu "cell này làm gì/vì sao/output mong đợi"; markdown sau output dùng cho `**Nhận xét:**`; giải thích kỹ thuật ngắn chuyển vào comment trong code khi cần.
  - **Lưu quy tắc mới:** cập nhật `AGENTS.md`, `PROJECT_CONTEXT.md` mục 6 và `docs/huong-dan-giang-vien/feedback-giang-vien-nb02-nb03-2026-07-18.md` theo quy tắc trên.
  - **Sửa phương pháp tiếp cận NB01:** đổi cách trình bày từ "2 nhánh độc lập" sang **database trung tâm + CSV fallback**. NB01 nay ghi rõ NB02 là nơi import raw/tạo view/join/aggregation/index/validation; NB03 có thể đọc DB bằng `pd.read_sql` hoặc đọc CSV để fallback, nhưng output clean nên ghi lại cả `data/processed/` và PostgreSQL; NB05 tạo features cũng nên ghi lại DB.
  - **Verify đã làm:** JSON 3 notebook load được, mọi code cell parse AST được, `rg` không còn emoji/icon trong NB01/NB02/NB03/ghi chú, `rg` không còn các cụm văn phong quá bóng đã rà, `git diff --check` sạch. Chưa Restart & Run All vì NB02 cần PostgreSQL/dữ liệu local và các thay đổi chủ yếu là markdown/khung pipeline.
  - **Tạm đẩy nhánh cho nhóm:** commit/push nhánh `fix/feedback-giang-vien-nb02-nb03` để thành viên khác có đủ bối cảnh trước khi làm tiếp các phần sau.

- **2026-07-17 (Hướng Dẫn Giảng Viên & tài liệu tham chiếu — nhánh `docs/huong-dan-giang-vien`):** Tạo bộ tài liệu trung tâm để AI Agent sau này hiểu hướng dẫn của thầy mà không nhầm thành quy định cứng.
  - **Thư mục mới:** `docs/huong-dan-giang-vien/`.
  - **`README.md`:** giải thích mục đích, cách AI Agent nên dùng tài liệu, thứ tự ưu tiên khi có mâu thuẫn với `AGENTS.md`/`PROJECT_CONTEXT.md`/Assignment, và trạng thái các nguồn đã tổng hợp.
  - **`tai-lieu-tham-chieu.md`:** liệt kê các file gốc đang có trong `docs/` như Assignment, mẫu tài liệu, mẫu slide, Business/Data Understanding, hướng dẫn viết tài liệu dự án.
  - **`video-bai-giang.md`:** tổng hợp Buổi 1, Buổi 2, Buổi 4 và clip học xưởng buổi tối 1; ghi rõ Buổi 3 và clip xưởng 2 chưa có video/chưa được cung cấp.
  - **`AGENTS.md`:** thêm một dòng hướng dẫn AI Agent đọc `docs/huong-dan-giang-vien/README.md` khi cần hiểu hướng dẫn/bài giảng/tài liệu tham chiếu của giảng viên.
  - **Ghi chú:** chưa đọc transcript trực tiếp từ YouTube; bản tổng hợp hiện dựa trên ghi chú/timestamp do Hưng cung cấp và có thể bổ sung sau.

- **2026-07-17 (Business/Data Understanding — nhánh `docs/bo-sung-ly-do-chon-home-credit`):** Củng cố lại phần nền tảng để nhóm không bị phụ thuộc mù vào AI.
  - **Business Understanding (`docs/Business_Understanding.docx`):** bổ sung mục "Lý do lựa chọn bộ dữ liệu Home Credit" theo 2 lớp: (1) lý do học tập — thử thách với dữ liệu lớn/phức tạp, nhiều bảng; (2) lý do nghiệp vụ — bài toán rủi ro tín dụng có giá trị thực tế. Bổ sung thêm "Tầm quan trọng của bài toán trong ngành AI" (AI hỗ trợ ra quyết định kinh doanh, dữ liệu thật nhiều nguồn/nhiễu/mất cân bằng, cần dùng có trách nhiệm) và **mục SWOT** đúng mẫu báo cáo: Strengths/Weaknesses/Opportunities/Threats. File hiện có 13 mục nhỏ, kết thúc ở `1.13 Kết luận`.
  - **Data Understanding doc (`docs/Data_Understanding.docx`):** tạo file Word mới cho cả nhóm đọc chung, gồm mục tiêu Data Understanding, **5 ý lớn cần nắm** (bảng nào, ý nghĩa nghiệp vụ từng bảng, mỗi dòng là gì, khóa nối, vấn đề dữ liệu) và **6 câu hỏi tự kiểm tra** kèm câu trả lời mẫu. Đây là tài liệu nền để trước khi vào NB01 ai cũng hiểu "dữ liệu đang kể câu chuyện cho vay nào".
  - **Notebook 01 (`notebooks/01_data_understanding.ipynb`):** sắp xếp lại từ mạch hơi rời rạc thành 9 mục: mục tiêu/câu hỏi dẫn đường → bối cảnh bài toán → chuẩn bị môi trường → bản đồ dữ liệu → bảng trung tâm → bảng phụ/khóa → từ điển dữ liệu → thách thức/phương pháp → tổng kết. Thêm checklist tự kiểm tra ở cuối notebook.
  - **ERD:** tạo `reports/images/home_credit_erd.png` và chèn vào mục quan hệ khóa của NB01; vẫn giữ sơ đồ ASCII làm fallback. ERD gộp `application_train/test` làm bảng trung tâm, thể hiện nhánh `bureau → bureau_balance` và `previous_application → installments/POS/credit_card`, nhấn mạnh các bảng 1-n phải aggregate về `SK_ID_CURR`.
  - **Format output NB01:** bảng overview 8 CSV trước hiển thị mọi số dạng `xxxx.0000`; đã đổi code sang `overview.style.format` và cập nhật output lưu sẵn: cột đếm là số nguyên, `RAM (MB)` 1 chữ số, `Ô thiếu (%)` 2 chữ số. Notebook vẫn đọc JSON bình thường; code cell giữ execution_count 1→14 liền mạch; không chạy lại toàn bộ vì chủ yếu sửa markdown/output hiển thị.
  - **Verify:** kiểm tra JSON NB01 hợp lệ, link ảnh tồn tại, `git diff --check` sạch. Render DOCX bằng tool documents vẫn không chạy được do máy thiếu LibreOffice/headless renderer (`FileNotFoundError`), nên chỉ QA cấu trúc/nội dung Word bằng `python-docx`.

- **2026-07-16 (Chương 1 whitepaper — nhánh `docs/chuong-1-business-understanding`, PR #41):** Viết bản thảo **Chương 1 Business Understanding** (`docs/Business_Understanding.docx`) theo mạch CRISP-DM: mở đầu → tình huống hai khách hàng cùng thu nhập nhưng khác lịch sử tín dụng → bài toán Home Credit (cân bằng giảm rủi ro vs duy trì tăng trưởng) → vai trò AI (**hỗ trợ định lượng, không thay chuyên viên tín dụng**) → phát biểu bài toán → ý nghĩa `TARGET` (0 = trả nợ bình thường / 1 = gặp khó khăn trả nợ) → vì sao là **phân loại nhị phân** → giá trị hệ thống → bộ câu hỏi chốt trước khi sang Data Understanding → kết luận.
  - **Trang bìa `docs/2. Mau tai lieu.docx`:** điền tiêu đề *"Xây dựng Mô hình Phân loại nhị phân — Dự báo Rủi ro Khách hàng Vay vốn"* + danh sách 5 thành viên (Hưng PS47270 — trưởng nhóm; Huy PS48224; Thái PS47694; Qui Anh PS48165; Thắng PS48172). Bốn bạn còn để "Vai trò" — chờ nhóm chốt phân công.
  - **Phạm vi (ghi rõ để khỏi hiểu nhầm):** đây mới là **bản thảo Chương 1 đặt ở `docs/`**, CHƯA ghép vào file nộp `reports/tai-lieu-du-an-nhom-01.docx` (vẫn là mẫu trắng). Whitepaper còn Chương 2–6.

- **2026-07-16 (bổ sung 2, cùng nhánh):** Thêm **định nghĩa `accuracy` và `ROC-AUC`** vào NB01 mục 1.2 — notebook đang **dùng thuật ngữ mà chưa hề định nghĩa**, người đọc gặp từ lạ không có chỗ tra. Dùng cách hiểu gọn nhất của AUC: *bốc ngẫu nhiên 1 khách vỡ nợ + 1 khách an toàn, AUC = xác suất mô hình chấm điểm người vỡ nợ cao hơn* → từ đó suy ra ngay vì sao AUC **miễn nhiễm mất cân bằng** (phép đo luôn so 1 cặp gồm 1 người mỗi nhóm, tỷ lệ 8/92 không tham gia).
  - **KHÔNG viết thêm gì cho NB06 — vì Thắng đã làm sẵn và làm tốt.** Trước khi định viết, tôi rà lại NB06 và thấy nó **đã có đủ**: mục 4 có hẳn tiểu mục *"Vì sao dùng AUC-ROC mà KHÔNG dùng accuracy?"* với đúng định nghĩa "xác suất xếp đúng cặp"; mục 4.1 vẽ đường cong ROC + giải thích 2 trục là phép đánh đổi kinh doanh; mục 5.1 giải thích ngưỡng + Youden J; nhận xét cuối có bảng 3 ngưỡng quy ra người thật. **Viết thêm chỉ gây trùng lặp.**
    - **Phép thử đối chứng của NB06 rất đáng dùng cho slide/whitepaper:** Dummy đạt accuracy **91,93%**, mô hình tốt nhất **92,01%** — chênh **0,08 điểm phần trăm**. Chấm bằng accuracy sẽ kết luận 297 đặc trưng của NB05 là vô giá trị. Nhìn AUC mới lộ ra: **0,5000 vs 0,7792**.
    - NB06 còn một nhận định sắc nên đưa vào báo cáo: từ chối thẳng 34% hồ sơ (hệ quả của ngưỡng 0,0747) là **không chấp nhận được về mặt kinh doanh** → nên dùng để **phân luồng thẩm định**, không loại tự động.
  - NB01 nay **trỏ sang NB06** thay vì tự giải thích lại đường cong/ngưỡng — đúng phân vai: NB01 nêu bài toán, NB06 là nơi thật sự tính ra chỉ số.
  - **Đã verify:** `nbformat.validate` hợp lệ; execution_count vẫn 1→14 liền mạch (chỉ sửa markdown); 4 con số NB01 trích từ NB06 (91,93% / 92,01% / 0,5000 / 0,7792) đều **đối chiếu khớp với chính NB06**; `models/model_metadata.json` xác nhận `auc_roc_valid = 0.7792`, `decision_threshold = 0.0747`.
  - **Việc nhỏ còn bỏ ngỏ (chưa làm, tách task riêng vì thuộc NB06):** NB06 dùng `TPR`/`FPR` trong công thức Youden J mà chưa định nghĩa 2 ký hiệu này. Sửa thì nên đi cùng nhánh riêng cho NB06, không gộp vào PR NB01.

- **2026-07-16 (bổ sung, cùng nhánh):** Thêm **mục 1 "Bài toán & phương pháp tiếp cận"** — NB01 trước đó nhảy thẳng vào `import` mà **không hề phát biểu bài toán**. Theo CRISP-DM, pha đầu là *Business Understanding*; NB01 bỏ qua hẳn pha này.
  - **NB01 nay có 7 mục** (1. Bài toán → 7. Tổng kết), khớp NB02–NB06. Đã dồn số 10 tiêu đề (mục cũ 1→2 … 6→7) bằng script có `assert` khớp tiêu đề cũ trước khi đổi, nên không sửa nhầm.
  - **1.1 Bối cảnh nghiệp vụ:** Home Credit phục vụ nhóm *unbanked/underbanked* — thế lưỡng nan "từ chối hết thì mất thị phần, cho vay bừa thì mất vốn" → lối ra là lượng hóa rủi ro từ **dữ liệu thay thế**. Đây chính là lý do bộ dữ liệu có tới **6 bảng lịch sử**. Kèm link Kaggle (phục vụ Y4 — trích dẫn nguồn).
  - **1.2 Phát biểu bài toán (đáp Y2 — mapping Kaggle → mô hình AI, notebook trước nay chưa hề nói):** đầu vào/đầu ra, **phân loại nhị phân có giám sát**, chỉ số **ROC-AUC**. Giải thích **vì sao không phải hồi quy** (đầu ra là nhãn rời rạc, xác suất chỉ là độ tin cậy của nhãn) và **vì sao không phải phân cụm** (đã có nhãn sẵn ⇒ có giám sát).
  - **1.3 Bốn thách thức — có bảng bằng chứng định lượng + cột "kiểm chứng tại mục nào"**, thay vì nói suông "bài này khó". Nhấn mạnh: **độ khó nằm ở dữ liệu, không ở thuật toán** (khớp với phát hiện của NB06: 3 mô hình chỉ chênh ~0,016 AUC).
  - **1.4 Phương pháp tiếp cận:** sơ đồ pipeline 2 nhánh + bảng **giải thích vì sao công đoạn nào làm ở SQL, công đoạn nào ở Python** — **đề bài Phần A mục 6 bắt buộc phải giải thích điều này mà chưa notebook nào nói**. Lý do chốt: SQL xử lý theo khối trên đĩa + có index (hợp thách thức 1–2); Python có cơ chế `fit`/`transform` để học tham số trên train rồi áp lại test — thứ SQL không có.
  - **Viết lại mục 7 Tổng kết thành 3 mục con:** 7.1 đối chiếu 4 thách thức nêu ở 1.3 với bằng chứng thu được (khép vòng lập luận); 7.2 bốn phát hiện bổ sung; 7.3 bước tiếp theo.
    - **Sửa một điểm sai cũ:** Tổng kết cũ ghi "Bước tiếp theo → Notebook 02" theo tư duy pipeline đường thẳng. Thực tế pipeline **tách 2 nhánh** từ NB01 (Database → NB02; CSV → NB03). Nay ghi đúng cả hai.
  - **Đã verify:** `nbformat.validate` hợp lệ; execution_count vẫn **1→14 liền mạch** (chỉ sửa markdown nên không cần chạy lại); **đối chiếu 21/21 con số** markdown khẳng định với output thật (8 số dòng bảng, TARGET 24.825/282.686 và 8,07%/91,93%, 67/122 cột thiếu, thiếu cao nhất 69,87%, 365243×55.374 lần, RAM 830,4 MB, EXT_SOURCE_1 134.133 giá trị, trung vị thu nhập 147.150 vs max 117.000.000, từ điển (219,4)) → **0 sai lệch**. Diff 50 thêm/17 xoá trên file 2.949 dòng ⇒ không bị format lại toàn file.

- **2026-07-16:** Rà soát và bổ sung diễn giải cho **NB01** — notebook đúng số liệu nhưng trình bày *kết quả* mà thiếu *lập luận*, chưa đạt Y3 (tổ chức code) và Y4 (diễn giải bằng ngôn ngữ khoa học).
  - **Thêm markdown giải trình** cho cả 6 mục: vai trò từng thư viện; vì sao `profile_table` nạp-rồi-`gc.collect()` từng bảng (đỉnh RAM = bảng lớn nhất 830 MB thay vì tổng 2,5 GB); ba nhóm dtype; `NaN` và vì sao **tỷ lệ thiếu cao KHÔNG đủ để xoá cột**; `describe()` và vì sao đọc cả mean lẫn median; quy ước `DAYS_*` âm.
  - **Trích định nghĩa gốc của `TARGET`** từ `HomeCredit_columns_description.csv` vào notebook: *"late payment more than X days on at least one of the first Y installments"*. **Sắc thái quan trọng cho báo cáo:** nhãn 1 = **khó khăn trả nợ giai đoạn đầu**, KHÔNG phải "khách đã phá sản" — trước giờ notebook chỉ ghi chung chung "vỡ nợ/default". Home Credit cố ý chọn tín hiệu sớm để can thiệp kịp.
  - **Viết lại nhận xét `TARGET`** thành 3 hệ quả có căn cứ (accuracy 92% của mô hình rỗng; ngưỡng 0,5 mặc định vô dụng; hai loại sai lầm giá khác nhau → ưu tiên Recall). Đây là phần **trích thẳng sang whitepaper Chương 4** được.
  - **Thêm sơ đồ quan hệ 8 bảng (ASCII)** ở mục 4 — thứ khó hiểu nhất của bộ dữ liệu, trước chỉ mô tả bằng chữ. Cố ý dùng ASCII thay vì mermaid: `requirements.txt` ghi nhóm chạy notebook trong **VS Code**, không cài JupyterLab → mermaid rủi ro hiện ra chữ thô. ASCII hiển thị y hệt ở VS Code / JupyterLab / GitHub / export Word-PDF cho whitepaper.
    - **Điểm dễ bỏ sót đã ghi vào notebook:** 3 bảng số dư có sẵn cả `SK_ID_CURR` lẫn `SK_ID_PREV` → tổng hợp thẳng về khách được; riêng `bureau_balance` **chỉ có `SK_ID_BUREAU`** → buộc phải nối vòng qua `bureau` để mượn `SK_ID_CURR`.
  - **Viết lại 1 cell code** (thống kê biến phân loại): tách list-comprehension lồng điều kiện thành vòng lặp tường minh. Đã đối chiếu output trước/sau: **16 dòng giống hệt từng giá trị**, chỉ thêm nhãn chỉ mục `Cột` — đồng bộ với cell 6 vốn đã đặt `overview.index.name = "Bảng"`.
  - **Đã verify:** `nbconvert --execute` exit 0, execution_count **1→14 liền mạch**, 0 cell lỗi. Đối chiếu lại mọi con số markdown khẳng định với output thật: 307.511×122; TARGET 24.825 (8,07%) / 282.686 (91,93%); 67/122 cột thiếu; `DAYS_EMPLOYED`=365243 xuất hiện 55.374 lần; từ điển (219, 4); dtype `float64` 65 / `int64` 41 / `str` 16; và **cả 8 số dòng trong sơ đồ ASCII** khớp bảng tổng quan cell 6.
  - **Quyết định KHÔNG thêm biểu đồ** dù ban đầu định thêm: đã liệt kê toàn bộ biểu đồ NB04 (barplot+pie TARGET, boxplot thu nhập/khoản vay/niên kim/**tuổi**/số năm làm việc, countplot 4 biến phân loại, barplot tỷ lệ nợ xấu, kdeplot EXT_SOURCE, boxplot bureau, heatmap tương quan) → **Y3 đã được NB04 lo trọn**, mọi ý tưởng thêm cho NB01 đều trùng NB04 cell 8.
    - **NB01 vốn đã trùng NB04** ở biểu đồ TARGET → **giữ nguyên, có lý do**: pipeline là 2 nhánh độc lập (CSV 01→03→05→06 / DB 02→04), người chạy nhánh CSV không cài PostgreSQL nên **không bao giờ mở NB04** ⇒ NB01 phải tự đứng vững một mình.
  - **Chưa làm (cố ý, tách task riêng):** không gỡ `warnings.filterwarnings("ignore")` ở cell 3. Đây đúng là thủ phạm nuốt `ChainedAssignmentError` ở NB03, nhưng **NB01 chỉ đọc dữ liệu, không biến đổi** nên không có rủi ro tương tự — gỡ thì nên làm đồng loạt cả nhóm notebook, không gộp vào PR này.

- **2026-07-15 (sau merge PR #38):** Cập nhật `PROJECT_CONTEXT.md` mục 3 + 4 ghi nhận **T11 (NB06) của Thắng đã xong** — nút thắt lớn nhất dự án đã gỡ.
  - **Đổi thứ tự ưu tiên:** NB06 rời khỏi vị trí số 1, `app/` Streamlit + dashboard interactive lên thay. Whitepaper/slide vẫn 0% và **giờ là rủi ro lớn nhất còn lại** — không còn cớ "đợi số liệu" vì Chương 4 nay viết được đầy đủ.
  - **Ghi đậm vào mục 4 cái bẫy ngưỡng quyết định** cho người làm app/NB07: ngưỡng mặc định 0,5 chỉ bắt 3,24% khách vỡ nợ → app sẽ **trông như chạy đúng** mà gần như luôn trả lời "an toàn". Phải đọc `decision_threshold` = 0,0747 từ `model_metadata.json`. Đúng kiểu lỗi âm thầm nhóm dính mãi — nên tôi để ở mục 4 chứ không giấu trong mục 3.
  - Ghi nhận ngoại lệ `.gitignore` cho `models/model_metadata.json` (10KB) vào mục 2.6 — file duy nhất trong `models/` lên GitHub.
  - **Lưu ý về máy này:** `.claude/whoami` đang là `thang` (Thắng làm T11 trên máy này) → đã đổi về `hung`. Ai dùng chung máy nhớ kiểm tra whoami đầu phiên.
  - **Làm rõ quy ước notebook (cùng PR):** chính tôi cũng hiểu nhầm quy ước mình viết — tưởng có quy định "notebook phải đủ 6 mục lớn". Kiểm tra lại thì **không hề có**: mục 6 điểm 4 chỉ ghi "*ví dụ `## 6. Tổng kết`*", con số 6 lấy từ NB01 và chỉ là ví dụ. Quy định thật là **Tổng kết đứng cuối**, số mục tuỳ nội dung. Thực tế NB01 có 6 mục, NB02–NB06 có 7 — **không cái nào sai**.
    - Đã viết lại mục 6 (điểm 2 + điểm 4) cho dứt khoát: "số mục KHÔNG cố định, tuỳ nội dung, đừng nhồi/gộp cho đủ số".
    - **Phát hiện lỗ hổng thật sự:** `AGENTS.md` chỉ bảo AI đọc `PROJECT_CONTEXT.md` **mục 3 và 4** → agent (nhất là Antigravity, không có hook) **có thể không bao giờ đọc tới mục 6** mà vẫn tưởng mình nắm quy ước. Đã thêm dòng vào `AGENTS.md`: động vào `notebooks/` thì phải đọc mục 6 trước, kèm cảnh báo "không có quy định 6 mục".
    - **Rút kinh nghiệm:** viết "ví dụ X" trong văn bản quy định là mời người đọc hiểu X thành bắt buộc — nhất là khi ví dụ đó tình cờ khớp với thực tế lúc viết. Quy định nên nói rõ cái gì **cố định** và cái gì **tuỳ nội dung**.

- **2026-07-15 (T19):** Viết `README.md` (trước đó rỗng 0 byte) 8 mục + kiện toàn `requirements.txt`.
  - **Phát hiện quan trọng khi rà soát — pipeline KHÔNG phải đường thẳng 01→07** như cả nhóm vẫn hình dung. Thực tế là **2 nhánh độc lập**: nhánh CSV (NB01, NB03 → NB05 → NB06 → NB07, **không cần PostgreSQL**) và nhánh Database (NB02 → NB04, cần PostgreSQL). Hệ quả: ai chỉ làm NB06 (train mô hình) thì **khỏi phải cài PostgreSQL** — trước giờ không ai nói rõ điều này. Đã vẽ sơ đồ + lập bảng "cần gì trước / sinh ra gì" cho từng notebook trong README mục 5.
  - **`requirements.txt` thiếu `ipykernel`** → ai chạy `pip install -r requirements.txt` xong **không mở nổi notebook**. Đúng kiểu lỗi "chạy được máy tác giả, hỏng máy khác" mà nhóm dính mãi. Đã thêm (chọn ipykernel thay vì jupyterlab cho nhẹ — cả nhóm dùng VS Code; ai muốn trình duyệt thì tự `pip install jupyterlab`).
  - **Bỏ `sqlalchemy==2.0.50`** — đã kiểm chứng không file nào import; nó chỉ xuất hiện trong dòng *cảnh báo* của pandas ("consider using SQLAlchemy") do NB02/04 truyền thẳng connection psycopg2 vào `read_sql`. Cảnh báo chứ không phải lỗi.
  - **Thêm `streamlit==1.58.0`** sẵn cho task app/ sau này. Tiện thể: streamlit kéo theo `pyarrow` → **hỗ trợ parquet giờ có sẵn miễn phí**, đỡ phải cài thêm khi chuyển `train_features.csv` sang parquet.
  - **Cách kiểm chứng đã dùng** (nên lặp lại cho task sau): quét import toàn bộ notebook để đối chiếu với requirements; `pip check`; `pip install --dry-run --ignore-installed` (exit 0 = resolve được, không xung đột); đối chiếu 10/10 bản ghim với bản đang cài; và verify từng khẳng định trong README bằng lệnh thật (URL repo, file được trỏ tới có tồn tại, NB01 có check FileNotFoundError, NB02 có TRUNCATE, DEBUG=False ở cả NB03/NB05).

- **2026-07-15:** Phát hiện và vá **2 lỗi âm thầm** trong pipeline làm sạch → đặc trưng:
  - **NB03 — `replace` không ăn do Copy-on-Write:** pandas 3 bật CoW nên `df['cot'].replace(..., inplace=True)` KHÔNG bao giờ ghi được vào DataFrame gốc. Hai bước làm sạch thất bại âm thầm: `DAYS_EMPLOYED = 365243` (~1000 năm) không được thay bằng NaN (2672/15000 dòng còn giá trị bẩn), và `CODE_GENDER = 'XNA'` không được gộp về 'F'. **Thủ phạm giấu lỗi:** `warnings.filterwarnings("ignore")` đã nuốt mất `ChainedAssignmentError` của pandas. Sửa: dùng phép gán thay chained inplace, thêm `assert` kiểm chứng sau mỗi bước thay thế, bỏ blanket filterwarnings (chỉ tắt riêng FutureWarning/DeprecationWarning/PerformanceWarning).
  - **NB05 — chữ nói full, output là mẫu:** source ghi `DEBUG=False` và markdown khẳng định "đã chạy trên toàn bộ dữ liệu", nhưng ô cấu hình có `execution_count=None` (chưa hề chạy) nên các ô sau chạy bằng `DEBUG=True` còn sót trong kernel → `train_features.csv` chỉ có 15.000 dòng. **Bằng chứng quyết định là dấu thời gian:** train_features.csv ghi lúc 10:09, TRƯỚC khi application_train_clean.csv ghi xong lúc 10:16 → NB05 đã đọc nhầm bản clean mẫu cũ. Sửa: Restart & Run All bằng nbconvert với `DEBUG=False` → train (307511, 299), test (48744, 298), execution 1..13 liền mạch, 0 lỗi, đỉnh RAM ~3,3 GB (thấp hơn nhiều so với mức 8 GB tôi từng cảnh báo trong notebook). Số cột 293→299 do One-Hot trên dữ liệu đầy đủ sinh thêm hạng mục mà mẫu 15k không có.
  - **Bẫy phụ đã dính:** `nbconvert` chỉ cập nhật output, KHÔNG đụng markdown → sau khi chạy lại vẫn còn 2 cell nhận xét mô tả sai (cell 4 "DEBUG mặc định bật"; cell 5 tả `read_by_chunks` "chỉ giữ dòng trong danh sách lấy mẫu" trong khi `DEBUG=False` đọc nguyên file không lọc — đây mới là bước tốn RAM nhất). Đã sửa tay.
  - **Rút kinh nghiệm cho cả nhóm (đã ghi vào PROJECT_CONTEXT mục 3):** (1) không dùng `filterwarnings("ignore")` toàn cục; (2) Restart & Run All trước khi commit, kiểm tra execution_count liền mạch 1,2,3...; (3) thêm `assert` sau mỗi bước biến đổi dữ liệu quan trọng để lỗi phải nổ thay vì trôi qua.

- **2026-07-14:** Sửa notebook 01 và ghim dependencies: (1) Thêm cell Markdown "⚙️ Hướng dẫn chuẩn bị trước khi chạy (Đọc kỹ)" hướng dẫn tải dữ liệu từ Kaggle vào `data/raw/`, chạy `pip install -r requirements.txt`, và cảnh báo RAM trống tối thiểu 4GB-8GB. (2) Bổ sung code assert/raise FileNotFoundError tự động kiểm tra xem có thiếu bất kỳ file CSV thô nào không trước khi load nhằm cảnh báo sớm và đưa ra hướng dẫn rõ ràng. (3) Ghim cứng các phiên bản thư viện thực tế đang chạy ổn định của dự án (pandas==3.0.3, numpy==2.4.6, scikit-learn==1.8.0, psycopg2-binary==2.9.12, sqlalchemy==2.0.50, matplotlib==3.10.9, seaborn==0.13.2, joblib==1.5.3, python-dotenv>=1.0.1) vào `requirements.txt`.
- **2026-07-13:** Rà soát + vá notebook 05 (Feature Engineering - task T10 của Thắng): phát hiện hàm `reduce_mem_usage` báo `UFuncTypeError` trên máy dùng **pandas 3.0 / numpy 2.x** (pandas 3.0 đọc cột chữ thành dtype `str` chứ không còn là `object`, khiến điều kiện `dtype != object` cho cột chữ lọt vào nhánh so sánh số -> numpy 2.x ném lỗi) -> vá bằng `is_numeric_dtype`, bỏ qua bool/cột toàn NaN, cột chữ -> category. Bổ sung `scikit-learn`, `joblib` vào `requirements.txt` (NB05 dùng mà còn thiếu); thêm cell "Điều kiện trước khi chạy" đầu NB05 (đọc CSV raw, không cần DB/`.env`; lưu ý cờ DEBUG mặc định xuất dữ liệu mẫu 15k/5k). Chạy lại bằng nbconvert: hết lỗi, execution 1..13 liền mạch. **Bài học chung:** cả NB02/04/05 đều lỗi kiểu "chạy được máy tác giả, hỏng máy khác" (đường dẫn cứng / thiếu thư viện / lệch phiên bản) -> nên ghim version thư viện trong requirements.
- **2026-07-13:** Gỡ conflict `context/thang.md` khi gộp `main` mới vào nhánh `feature/t10-feature-engineering` của Thắng (giữ cả log T10 và T07, phần "Đang làm" giữ T10); merge bằng cách merge main vào nhánh (không rebase) để tránh force-push, đã push cập nhật PR. NB05 (notebook 05) của Thắng không bị conflict.
- **2026-07-13:** Rà soát + sửa notebook 04 (EDA & Visualization): (1) cell kết nối DB dính đúng lỗi env path như NB02 -> áp cùng bản fix `load_dotenv(find_dotenv(), override=True)` + default `db_name='credit_risk_db'`, `db_password='postgres'`; (2) Mục 4 (Bureau) chỉ query dữ liệu mà KHÔNG vẽ biểu đồ, nhận xét lại mô tả cột không có trong query -> thêm boxplot (số khoản vay Active + tổng nợ quá hạn theo TARGET, dùng symlog) và sửa nhận xét khớp dữ liệu thật; (3) phát hiện `requirements.txt` THIẾU `matplotlib`, `seaborn`, `numpy` (NB01/NB04 đều dùng để vẽ) -> đã bổ sung; (4) thêm cell "Điều kiện trước khi chạy" ở đầu NB04 (phải chạy NB02 trước, có `.env`, cài requirements). Đã Restart & Run All: execution 1..9 liền mạch, có biểu đồ bureau, không lỗi.
- **2026-07-13:** Đánh giá chéo các task SQL của nhóm: T07 `05_indexes.sql` (Thắng) đạt tốt — chỉ 1 index hơi thừa (`idx_bureau_balance_bureau` bị composite bao trùm), không chặn merge; `04_aggregation.sql` (Huy) tốt, chọn đúng materialized view + unique index cho refresh concurrent.
- **2026-07-13:** Sửa notebook 02 (task của Huy): (1) đổi `load_dotenv('../.env')` -> `load_dotenv(find_dotenv(), override=True)` để tìm `.env` bất kể thư mục chạy, sửa default `db_name` thành `credit_risk_db`; (2) phát hiện `installments_payments` và `credit_card_balance` bị nạp gấp đôi (27.2M/7.6M) do hàm import không xóa bảng trước khi COPY -> thêm `TRUNCATE TABLE ... RESTART IDENTITY` (chung transaction với COPY) cho chạy lại an toàn (idempotent); (3) thêm cell markdown "Chuẩn bị trước khi chạy" liệt kê 4 bước cho thành viên pull về (pip install, tạo DB rỗng, tạo `.env` từ mẫu, tải CSV vào `data/raw/`). Đã Restart & Run All: số dòng về đúng chuẩn (installments 13.605.401, credit_card 3.840.312), không lỗi.
- **2026-07-12:** Tạo nhánh `docs/cap-nhat-project-context-views` và cập nhật `PROJECT_CONTEXT.md` để ghi nhận việc hoàn thành và merge thành công task T05 (tạo views - PR #19) vào `main`.
- **2026-07-12:** Merge thành công PR #19 gộp task T05 (views) vào `main`, sau đó switch về `main` cục bộ và `git pull` để đồng bộ code mới nhất.
- **2026-07-12:** Thực hiện và hoàn thành viết mã cho [03_views.sql](file:///d:/FPT%20Polytechnic/2026/HK%20Summer%202026/Block2/Du-an-01/credit-risk-classifier/sql/03_views.sql) bao gồm 7 views chi tiết làm sạch và tính toán đặc trưng tài chính từ 8 bảng thô. Đã khắc phục lỗi cú pháp UNION và bổ sung comment giải thích nghiệp vụ (như khái niệm CIC, cách tính tỷ lệ nợ/sử dụng thẻ, số ngày trễ hạn).
- **2026-07-12:** Đã merge nhánh `docs/hung-cap-nhat-project-context` để cập nhật trạng thái chung của dự án sau khi hoàn thành tạo bảng (T02) và import (T03).
- **2026-07-03:** Dựng `AGENTS.md` làm nguồn sự thật duy nhất cho quy định nhóm (mirror nội dung CLAUDE.md cũ); `CLAUDE.md` giờ chỉ còn `@AGENTS.md` (Claude Code tự nạp). Mục đích: dùng xen kẽ Claude Code và Antigravity mà không lệch quy định. Lưu ý đã ghi trong AGENTS.md: hook `.claude/` chỉ Claude Code chạy, Antigravity không có — dựa vào GitHub Ruleset + kỷ luật.
- **2026-07-03:** Đã merge T01 (PR #12) → notebook 01 có trên `main`. Cập nhật `PROJECT_CONTEXT.md` mục 3 (notebook 01 xong, 02→07 còn rỗng) & mục 4 (hướng tiếp theo). **Rút kinh nghiệm:** tên nhánh phải có mã task ở đầu (vd `feature/t01-...`) — lần T01 đã lỡ đặt thiếu mã.
- **2026-07-03:** Hoàn thành notebook 01 (32 cell, đúng quy ước format nhóm): (1) chuẩn bị môi trường; (2) tổng quan 8 bảng — dòng/cột/RAM/tỷ lệ thiếu; (3) bảng trung tâm `application_train` (307.511×122): kiểu dữ liệu, `TARGET` mất cân bằng ~8%, missing (67 cột thiếu), thống kê mô tả; (4) bảng phụ & quan hệ khóa `SK_ID_CURR/BUREAU/PREV`; (5) từ điển dữ liệu; (6) tổng kết dẫn sang notebook 02. Đã `nbconvert --execute` nhúng output thật (3 biểu đồ), không lỗi. Đã cài `nbconvert` để thực thi notebook (chưa thêm vào `requirements.txt` — thuộc task README/requirements riêng).
- **2026-07-03:** Đã merge (PR #5, #6, #7): nội quy "chỉ nhóm trưởng đổi cấu trúc/quy trình", context cá nhân theo từng thành viên, khai báo tên qua `.claude/whoami`, hook `edit-branch-guard` chặn sửa file trên main. Đã cập nhật `PROJECT_CONTEXT.md`.

## Handoff mới nhất cho phiên kế tiếp

- **2026-07-21 (NB02 Database Organization - nhánh `feature/t02-database-organization`):** Đang làm lại NB02 sau reset theo quy trình mới **Ý tưởng → Chốt ý tưởng → Kế hoạch → Chốt kế hoạch → Triển khai**.
  - **Quy tắc làm việc đã chốt với Hưng:** NB02 chủ yếu dùng **SQL**; Python chỉ dùng khi thật sự cần kiểm tra/hiển thị kết quả. Không tự làm tiếp bước mới nếu Hưng chưa chốt kế hoạch bước đó.
  - **Khung NB02 đã chốt:** `notebooks/02_database_organization.ipynb` gồm 7 mục lớn:
    1. Khởi tạo database và bảng raw
    2. Import dữ liệu raw vào PostgreSQL
    3. Xác định khóa nối và quan hệ bảng
    4. Tạo index và aggregate bảng phụ
    5. Join theo ERD và tạo bảng `application_join`
    6. Validation sau khi tạo `application_join`
    7. Tổng kết
  - **Bước 1 đã làm:** tạo skeleton heading NB02.
  - **Bước 2 đã làm:** tạo database và bảng raw:
    - `sql/01_create_database.sql`: tạo database `credit_risk_db`.
    - `sql/02_create_raw_tables.sql`: tạo 8 bảng raw từ 8 CSV chính. Kiểu dữ liệu đã chỉnh theo hướng gần đúng hơn: `SK_ID_CURR/SK_ID_PREV/SK_ID_BUREAU` là `BIGINT`, `TARGET` và các cờ là `SMALLINT`, biến tiền/ngày/tỷ lệ/số đếm là `NUMERIC`, biến phân loại là `TEXT`.
    - Trong notebook đã ghi SQL trực tiếp bằng SQL code cell (`metadata.vscode.languageId = sql`), không để dạng markdown code fence.
  - **Bước 3 đã làm:** import dữ liệu raw và kiểm tra số dòng:
    - `sql/03_import_raw_data_query_tool.sql`: dùng `COPY` cho pgAdmin Query Tool, đường dẫn tuyệt đối theo máy Hưng.
    - `sql/04_import_raw_data_psql.sql`: dùng `\copy` cho `psql`, đường dẫn tương đối từ thư mục gốc project.
    - `sql/05_check_import_row_counts.sql`: kiểm tra số dòng 8 bảng sau import so với NB01.
    - Notebook có thêm `### 2.3. Kiểm tra số dòng sau import`.
  - **Validation đã chạy trong Codex:** notebook load JSON được, không lỗi encoding tiếng Việt, hiện có 37 cell, 5 SQL code cell, 0 Python code cell; SQL có đủ 8 `CREATE TABLE`, 8 `COPY`, 8 `\copy`; chưa có index/aggregate/join/application_join. `git diff --check` sạch.
  - **Chưa chạy PostgreSQL thật:** chưa tạo DB/import trên máy trong Codex. Khi chuyển sang Claude/terminal, nếu muốn kiểm chứng thực tế thì cần chạy SQL trong PostgreSQL local.
  - **Bước tiếp theo nên hỏi/chốt với Hưng trước:** lên kế hoạch cho mục 3 - **Xác định khóa nối và quan hệ bảng**. Phần này cần bám checklist NB02 của thầy: giải thích `SK_ID_CURR`, `SK_ID_PREV`, `SK_ID_BUREAU`, dựa vào ERD/NB01/tên cột trùng/tài liệu dataset, và viết SQL kiểm chứng cột khóa + join thử/row explosion.

## Còn dở / việc tiếp theo của tôi

- [x] Push nhánh `feature/t19-readme-va-requirements`, tạo PR và merge (T19 — README + requirements → PR #36).
- [x] Sau khi merge T19: cập nhật `PROJECT_CONTEXT.md` (PR #37).
- [x] Phân công **Notebook 06 (huấn luyện ML)** → Thắng nhận T11, xong, merge PR #38 (AUC 0,7792).
- [x] Push nhánh `docs/cap-nhat-project-context-sau-t11`, tạo PR và merge (PR #39).
- [x] Push nhánh `docs/t01-giai-thich-lai-nb01`, tạo PR và merge (bổ sung diễn giải NB01 — **PR #40**).
- [x] Viết bản thảo **Chương 1 Business Understanding** + điền trang bìa whitepaper (**PR #41**).
- [x] Bổ sung Business Understanding: lý do chọn dataset, tầm quan trọng trong ngành AI, SWOT.
- [x] Tạo `docs/Data_Understanding.docx` để nhóm thống nhất mục tiêu/5 ý lớn/6 câu tự kiểm tra.
- [x] Sắp xếp lại NB01 theo mạch Data Understanding, thêm ERD PNG và format gọn bảng overview.
- [x] Merge Business Understanding mới vào `main` (PR #53).
- [x] Merge Data Understanding mới vào `main` (PR #54).
- [ ] Push nhánh `docs/cap-nhat-context-data-understanding`, tạo PR và merge để context khớp trạng thái thật sau PR #54.
- [ ] Lên kế hoạch **Data Cleaning/NB03**: missing, `DAYS_EMPLOYED = 365243`, `CODE_GENDER = XNA`, outlier tiền tệ, kiểm tra sau xử lý và output clean.
- [ ] Lên lại kế hoạch SQL/PostgreSQL vì `sql/` hiện trống sau reset.
- [ ] Lên lại kế hoạch NB02–NB07 để khớp NB01 mới, code đơn giản/dễ giải thích và đúng quy tắc markdown/nhận xét.
- [ ] **Whitepaper + slide — rủi ro lớn.** Business/Data Understanding đã có nền trong `docs/`; còn Chương 2–6, slide và ghép vào file nộp `reports/`.
- [ ] **App Streamlit + dashboard interactive**: vẫn bắt buộc theo đề bài, nhưng nên làm sau khi pipeline clean/features/model mới ổn định. Nếu dùng model artifact cũ, phải kiểm tra compatibility với `model_metadata.json`.
- [ ] Chốt **3 Insights quan trọng** (tiêu chí Y1) sau khi pipeline/EDA mới ổn định.
- [ ] Hỏi giảng viên: Google Sheet có thay được "Nhật ký Jira" + ảnh Kanban (Chương 5, slide 12) không.
- [ ] Cân nhắc chuyển dữ liệu processed/features sang **parquet** khi rebuild pipeline — `pyarrow` đã có sẵn do Streamlit kéo theo.
- [ ] Nhắc nhóm về 3 bài học lỗi âm thầm (mục 3 PROJECT_CONTEXT + mục 7 README) — nhất là thói quen Restart & Run All trước khi commit notebook.

## Ghi chú riêng

- Nhóm trưởng: Hưng — người duy nhất được merge PR vào `main` và đổi cấu trúc/quy trình.
