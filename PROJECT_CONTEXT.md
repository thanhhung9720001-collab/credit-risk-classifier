# PROJECT CONTEXT — Prompt khôi phục ngữ cảnh

> **Cách dùng:** Khi bắt đầu phiên làm việc mới với Claude Code, gõ:
> `Đọc file PROJECT_CONTEXT.md để nắm ngữ cảnh dự án, sau đó tiếp tục làm việc với tôi.`

---

## 1. Tổng quan dự án

- **Tên đề tài (VI):** Xây dựng Mô hình Phân loại và Dự báo Rủi ro Khách hàng Vay vốn
- **Tên đề tài (EN):** credit-risk-classifier
- **Bối cảnh:** Đồ án môn **Dự án 1**, FPT Polytechnic, Block 2 — HK Summer 2026, làm theo nhóm (nhóm 01)
- **Mục tiêu:** Xây dựng mô hình machine learning phân loại rủi ro tín dụng — dự đoán khách hàng vay có khả năng vỡ nợ (default) hay không
- **Dữ liệu:** Bộ **Home Credit Default Risk** (Kaggle), ~2.5GB tại `data/raw/`:
  - `application_train.csv` / `application_test.csv` — đơn vay chính (bảng trung tâm, có cột target)
  - `bureau.csv`, `bureau_balance.csv` — lịch sử tín dụng từ tổ chức khác
  - `previous_application.csv` — các khoản vay trước đó tại Home Credit
  - `installments_payments.csv` — lịch sử trả góp
  - `credit_card_balance.csv`, `POS_CASH_balance.csv` — số dư thẻ tín dụng / POS
  - `HomeCredit_columns_description.csv` — mô tả các cột

## 2. Mục đích cuối cùng & sản phẩm phải nộp

> **Nguồn: `docs/1. Assignment .docx` — đọc thẳng file đó khi có tranh cãi, mục này chỉ là bản tóm tắt.**

### 2.1. Mục đích cuối cùng: một **AI Product**, KHÔNG phải một mô hình ML

Đề bài (Phần A, mục 9) yêu cầu rõ: *"Kết quả dự án được triển khai thành **ứng dụng web đơn giản**. **Người dùng bình thường** có thể: nhập dữ liệu đầu vào → nhận kết quả dự đoán/gợi ý."*

⚠️ **Mô hình ML chỉ là phần LÕI bên trong, không phải đích đến.** Đích đến là người không biết code mở web lên, nhập thông tin khách vay và nhận về "khách này rủi ro vỡ nợ bao nhiêu %". Toàn bộ NB01→NB06 chỉ là đường đi tới `model.pkl` để app đó dùng. Ai làm notebook cũng nên nhớ điều này để không dừng lại ở "train xong là hết việc".

### 2.2. Bốn sản phẩm phải nộp (đóng gói `.zip` — Phần C + Y4)

| # | Sản phẩm | Yêu cầu chính |
|---|---|---|
| 1 | **Mã nguồn** (`.ipynb`) | Chia module rõ ràng: Khai báo → Nạp dữ liệu → Joining → Cleaning → EDA → Feature Engineering → Kết luận |
| 2 | **Whitepaper** (`.docx`) | **6 chương** theo mẫu `docs/2. Mau tai lieu.docx` — xem 2.4 |
| 3 | **Slide** (`.pptx`) | 16 slide theo mẫu `docs/3. Mau bao cao.pptx` |
| 4 | **Ứng dụng web** | Flask / FastAPI / **Streamlit** / React + API — nhóm chọn Streamlit |

### 2.3. Chín thử thách bắt buộc (Phần A) — áp cho mọi bộ dữ liệu

1. Join nhiều CSV (quan hệ 1-n / n-n), giải quyết xung đột sau Join, **tối ưu bộ nhớ** với bảng hàng triệu dòng
2. Tự tạo **ít nhất 10 biến phái sinh** từ các bảng phụ
3. Xử lý lỗi logic / định dạng sai / khuyết thiếu — **giải trình lý do dựa trên cơ sở thống kê**
4. Trích xuất được các dự đoán có ý nghĩa
5. Triển khai trên **PostgreSQL**: import, thiết kế schema (khóa chính/ngoại), làm Cleaning/Join/Aggregation **trực tiếp bằng SQL**
6. **Chia pipeline 2 phần rõ ràng** — SQL (Join, Aggregation, Filtering, Indexing) vs Python (Feature Engineering, Statistical Cleaning, Modeling) — và **phải giải thích vì sao công đoạn đó làm ở SQL hay Python**
7. 🔴 **Dashboard trực quan INTERACTIVE** — *"cho phép người dùng tương tác (filter, chọn thời gian, nhóm dữ liệu…)"*. **Biểu đồ tĩnh matplotlib/seaborn KHÔNG thoả yêu cầu này.** Xem cảnh báo ở mục 4.
8. Huấn luyện ML: ít nhất 1 mô hình, **có so sánh HOẶC tối ưu mô hình**, giải thích ý nghĩa thực tế của kết quả
9. Xây dựng ứng dụng web (xem 2.1)

**Thử thách riêng của Home Credit (Phần B):** phải "đào" được biến đặc trưng từ bảng phụ (Bureau, Previous Applications) — ví dụ *tỉ lệ nợ quá hạn trung bình*, *tần suất vay trong 12 tháng qua*.

### 2.4. Sáu chương của Whitepaper (Phần C)

| Chương | Nội dung | Ghi chú |
|---|---|---|
| 1 | Phân tích ý tưởng | Bối cảnh, **phân tích SWOT**, câu hỏi nghiên cứu |
| 2 | Pipeline & Tiền xử lý | Kỹ thuật Joining bảng lớn, xử lý Outliers, tối ưu bộ nhớ, **kịch bản Unit test đảm bảo dữ liệu sau Join không sai lệch** |
| 3 | EDA & Feature Engineering | **Ít nhất 10 biến phái sinh** + các tương quan ẩn tìm được |
| 4 | Mô hình hóa & Dự báo | Thuật toán, chỉ số đánh giá, **ý nghĩa thực tế** của dự báo |
| 5 | Quản trị dự án | Phân chia vai trò; **Nhật ký Jira**; Chiến lược phân nhánh Git (Main/Feature) |
| 6 | Tổng kết & Triển khai | **Hướng dẫn chạy code (README)** ✅ đã có, hạn chế, hướng phát triển |

### 2.5. Tiêu chí đánh giá (Phần D)

- **Y1 — Nội dung & mức độ hoàn thành:** Join thành công **3–5 file**; đưa ra **ít nhất 3 Insights quan trọng** + 1 mô hình dự báo cụ thể; code chạy thông suốt đầu→cuối
- **Y2 — Kỹ năng vận dụng:** dùng đúng `.merge()`/`.join()` kèm tối ưu bộ nhớ; tư duy Feature Engineering; mapping bài toán Kaggle → mô hình AI
- **Y3 — Lập trình & tổ chức code:** module rõ ràng; **không lạm dụng copy-paste**, viết hàm/class cho tác vụ lặp; **dùng Vectorization thay vòng lặp `for`**; biểu đồ (Heatmap, Scatter, Boxplot) thay vì in bảng số khô khan
- **Y4 — Trình bày & tuân thủ:** nộp đúng format `.zip` (source code + data hoặc link nạp data + documentation); báo cáo có mục lục, hình minh họa; **tính trung thực — ghi rõ nguồn nếu tham khảo Kaggle Notebooks của người khác**

### 2.6. Bản đồ mã nguồn hiện tại

> Cập nhật 2026-07-22: sau khi Hưng reset để làm lại gọn hơn, trạng thái thật của repo đã khác pipeline cũ. Không dùng các notebook/SQL cũ làm nguồn sự thật nếu file không còn trong repo.

1. **Notebooks** (`notebooks/`): hiện có `01_data_understanding.ipynb` và `02_database_organization.ipynb`, cả hai đã hoàn thành và chạy lại sạch. NB03–NB07 cần được xây dựng lại theo kế hoạch mới.
2. **SQL** (`sql/`, PostgreSQL): có 11 file đánh số liền mạch `01_create_tables.sql` → `11_check_flat_nulls.sql`, đi kèm NB02. Mạch chạy: tạo bảng → import → kiểm tra số dòng và kiểu dữ liệu → index → 5 bảng summary → `application_flat` → validation. Mỗi file có một SQL cell tương ứng trong NB02.
3. **App** (`app/`): demo bằng **Streamlit** (`stream_app.py`, `pages/`, `prediction.py`) + có thể thêm API (`api.py`), hiện các file chính vẫn rỗng.
4. **Models** (`models/`): còn `model.pkl`, `scaler.pkl`, `model_metadata.json` từ pipeline cũ. Trước khi dùng cho app/NB07 cần kiểm tra tương thích với pipeline làm lại.
5. **Báo cáo** (`reports/`): Word + PowerPoint theo mẫu trường; theo dõi tiến độ nhóm bằng **Google Sheet** (nhóm trưởng quản lý, link ở nhóm chat — không nằm trong repo). ⚠️ Đề bài nhắc tới **Jira/Trello + ảnh bảng Kanban** (Chương 5 + slide 12) — cần hỏi giảng viên xem Google Sheet có được chấp nhận thay thế không.

## 3. Trạng thái hiện tại (cập nhật 2026-07-22)

- ✅ Đã dựng xong cấu trúc thư mục hoàn chỉnh
- ✅ Đã tải đầy đủ dữ liệu Home Credit vào `data/raw/`
- ✅ Có tài liệu môn học trong `docs/` (assignment, mẫu tài liệu, mẫu báo cáo)
- ✅ **Đã tạo bộ Hướng Dẫn Giảng Viên & tài liệu tham chiếu cho AI Agent** (`docs/huong-dan-giang-vien/`, nhánh `docs/huong-dan-giang-vien`): gồm README định hướng, danh sách tài liệu gốc trong `docs/`, tổng hợp video Buổi 1, Buổi 2, Buổi 4 và clip học xưởng buổi tối 1. `AGENTS.md` đã nhắc AI Agent đọc bộ tài liệu này khi cần hiểu hướng dẫn/bài giảng của thầy. Lưu ý: đây là **nguồn tham khảo/định hướng**, không thay thế đề bài gốc, `AGENTS.md` hay `PROJECT_CONTEXT.md`.
- ✅ Đã chốt **quy ước định dạng notebook** (xem mục 6) và tạo cell tiêu đề chuẩn cho cả 7 notebook
- ✅ Đã thiết lập **quy trình làm việc nhóm qua git** — gồm nhiều lớp:
  - **GitHub Ruleset**: `protect-main` (cấm push thẳng, bắt buộc PR, chặn force-push/xóa nhánh) + `chi-co-nhom-truong-duoc-merge` (chỉ nhóm trưởng merge được vào main)
  - **Hook Claude Code** (`.claude/settings.json` + `.claude/hooks/`): (1) đầu phiên tự fetch, nhắc pull, **chào theo tên + nhắc file context**; (2) chặn commit/push/merge trên main; (3) **chặn cả thao tác sửa file trên main** (`edit-branch-guard.sh`) — kể cả khi tự đổi về main mà Claude chưa biết
  - **Tài liệu**: `docs/QUY-TRINH-LAM-VIEC.md` (quy trình chi tiết + Phần 0 quyền đổi cấu trúc + Phần 6 context cá nhân) + `CLAUDE.md` (quy tắc cho Claude)
- ✅ **Nội quy (2026-07-03)**: chỉ **nhóm trưởng (Hưng)** được thay đổi cấu trúc thư mục / quy trình / quy định (Phần 0 quy trình)
- ✅ **Context cá nhân (2026-07-03)**: mỗi thành viên có 1 file `context/<tên>.md` (chỉ chủ nhân sửa → hết conflict); khai báo tên đầu phiên qua `.claude/whoami` (không commit). `PROJECT_CONTEXT.md` từ nay do **nhóm trưởng làm chủ** (bức tranh tổng)
- 🔄 **Triển khai nội dung code** (cập nhật 2026-07-22):
  - ✅ **Mốc reset làm lại gọn hơn (PR #52, 2026-07-20):** Hưng đã quyết định reset notebook/SQL để tránh tiếp tục vá trên nền cũ quá dài/khó giải thích. Sau reset, `notebooks/` chỉ còn NB01 và `sql/` trống. **Tính tới 2026-07-22 đã dựng lại xong NB02 và toàn bộ `sql/`** — xem hai mục PR #59 và PR #61 phía dưới. Các notebook NB03–NB07 vẫn cần làm lại theo kế hoạch mới.
  - ✅ **Business Understanding — hoàn thành bản docs mới (PR #53, 2026-07-20):** `docs/Business_Understanding.docx` đã được bổ sung mục tiêu nghiên cứu, giới thiệu dataset, giới thiệu công nghệ, lý do chọn Home Credit, tầm quan trọng trong ngành AI, SWOT và chỉnh lại heading/bullet. Đây là nền để viết Chương 1 trong whitepaper, nhưng vẫn cần ghép vào file nộp trong `reports/`.
  - ✅ **Data Understanding — hoàn thành giai đoạn hiện tại (PR #54, 2026-07-20):**
    - `docs/Data_Understanding.docx`: viết lại theo 7 mục rõ ràng, có mục tiêu, bản đồ dataset, khóa nối, kiểm tra cần làm, biểu đồ/tương quan, câu hỏi tự kiểm tra và kết luận.
    - `reports/images/home_credit_erd.png`: sửa ERD, bỏ bảng `HomeCredit_columns_description` khỏi sơ đồ.
    - `docs/nb01_data_understanding_outline.md`: lưu outline chốt trước khi viết notebook.
    - `notebooks/01_data_understanding.ipynb`: hoàn thành NB01, `Restart & Run All` thành công.
    - Nội dung NB01 đã có: overview 9 CSV, ERD, khảo sát `application_train`, `nunique`, `describe`, kiểm chứng `DAYS_EMPLOYED = 365243` và `CODE_GENDER = XNA`, missing/duplicate, phân bố `TARGET`, grain/khóa bảng phụ, biểu đồ numeric/category, top correlation với `TARGET`, heatmap và handoff sang notebook sau.
    - Phạm vi được giữ đúng: NB01 chỉ tìm hiểu dữ liệu, không cleaning, không modeling, không join trực tiếp bảng phụ 1-n.
  - ✅ **Notebook 02 — Database Organization (PR #59, 2026-07-22):** dựng lại toàn bộ pipeline PostgreSQL theo checklist NB02 của thầy.
    - `notebooks/02_database_organization.ipynb`: 9 mục lớn, 77 cell (15 SQL cell + 2 Python cell), đã chạy thật trên PostgreSQL 18.4.
    - `sql/` có **11 file đánh số liền mạch** `01_create_tables` → `11_check_flat_nulls`. Mỗi file có một SQL cell tương ứng trong notebook, mirror byte-for-byte (riêng `06_create_summary_tables.sql` tách thành 5 cell theo từng bảng summary).
    - Mạch làm: tạo database/bảng → import bằng `COPY` → kiểm tra số dòng và kiểu dữ liệu → tạo index → **5 bảng summary** gom bảng phụ về mức khách hàng → `LEFT JOIN` tạo **`application_flat` 307.511 dòng × 148 cột** → validation → kết nối Python.
    - **Đã sửa 3 lỗi kiểu dữ liệu** phát hiện trong quá trình import — xem ý số 4 ở mục bài học lỗi âm thầm phía dưới.
    - **Không khai báo được `FOREIGN KEY`:** mọi quan hệ đều có bản ghi mồ côi (`bureau` → `application_train` thiếu 42.320 khách vì họ thuộc `application_test`; các mã `SK_ID_PREV`/`SK_ID_BUREAU` mồ côi 38.847 / 37.422 / 11.372 / 43.041). Nguyên nhân là dataset Kaggle bị cắt khi trích xuất. Đã dùng index trên khóa nối thay thế và ghi rõ lý do trong notebook.
    - **Bỏ `bureau_balance` khỏi bước summary** vì bảng này không có `SK_ID_CURR` nên không nối thẳng về khách hàng được; checklist của thầy cũng chỉ liệt kê 4 bảng summary. Sẽ khai thác ở NB05 nếu cần.
    - Kết nối Python dùng `psycopg2` + `.env`, **không dùng SQLAlchemy** theo đúng ghi chú sẵn có trong `requirements.txt`. Điểm này lệch nhẹ với checklist thầy (thầy ghi cả SQLAlchemy) — xem mục 4.
  - ✅ **Bổ sung NB01 theo checklist cập nhật của thầy (PR #61, 2026-07-22):** thầy update `docs/Task Checklist for Each Notebook.docx`, thêm mục `VI. Khảo sát dữ liệu của bảng phụ` cho NB01.
    - NB01 nay có **9 mục lớn, 75 cell / 25 code cell**, `Restart & Run All` sạch, execution_count liền mạch **1→25**.
    - Thêm mục "Khảo sát dữ liệu bảng phụ": một hàm dùng chung đọc theo chunk, trả đủ 6 ý thầy yêu cầu cho cả 6 bảng phụ, kèm `describe()` và `value_counts()` cho `bureau` / `previous_application`.
    - Thêm **kiểm tra khóa ngoại mồ côi**. Sáu con số tính từ CSV bằng pandas **khớp tuyệt đối** với kết quả đo độc lập từ PostgreSQL ở NB02 — hai notebook, hai công cụ, cùng kết quả.
    - Phát hiện mới cho NB03: `bureau.AMT_CREDIT_SUM_DEBT` có giá trị âm tới `-4.705.600` (dư nợ không thể âm); các cột tiền lệch phải rất nặng (`AMT_CREDIT_SUM` có max gấp ~4.661 lần trung vị).
    - Phát hiện mới cho NB05: **không biến numeric nào một mình có tương quan mạnh với `TARGET`** (mạnh nhất chỉ `-0,18`), nên tín hiệu phải đến từ kết hợp nhiều biến; cặp `REGION_RATING_CLIENT` / `REGION_RATING_CLIENT_W_CITY` trùng nhau `+0,95` nên chỉ nên giữ một.
    - Cập nhật `docs/huong-dan-giang-vien/` cho khớp checklist mới (PR #60): **viết lại toàn bộ** file hướng dẫn NB02 vì bản cũ soạn trước khi có checklist chính thức nên thiếu 5/10 mục và có 3 câu hướng dẫn ngược với checklist.
  - 📌 **Các dòng lịch sử dưới đây ghi lại pipeline cũ trước reset.** Khi phân công task mới, ưu tiên trạng thái thật ở các dòng cập nhật 2026-07-20 và 2026-07-22 phía trên, và kiểm tra file đang tồn tại trong repo.
  - ✅ **Toàn bộ 5 script SQL — HOÀN THÀNH**: `01_create_tables.sql` (T02, PR #15 — schema 8 bảng, tối ưu kiểu số); `02_import_data.sql` (T03, PR #16/#17 — import CSV bằng `COPY`, ghi chú đổi đường dẫn từng máy); `03_views.sql` (T05, PR #19 — 7 view làm sạch + chỉ số nghiệp vụ CIC/dư nợ/trễ hạn/dùng thẻ); `04_aggregation.sql` (kèm pipeline T04, PR #23 — 3 materialized view tổng hợp installments/pos_cash/credit_card theo khách hàng, có unique index); `05_indexes.sql` (T07, PR #25 — index khóa ngoại + composite/partial cho bureau_balance & target).
  - ✅ **Notebook 01 (`01_data_understanding.ipynb`) — HOÀN THÀNH** (T01, PR #12): tổng quan 8 bảng, phân tích `application_train` (307.511×122, `TARGET` ~8%, 67 cột thiếu), quan hệ khóa, từ điển dữ liệu. **Bổ sung diễn giải kỹ thuật (2026-07-16, PR #40):** thêm mục "Bài toán & phương pháp tiếp cận" (phát biểu bài toán, phân loại nhị phân có giám sát, phân biệt ROC-AUC vs accuracy), giải nghĩa thuật ngữ Anh–Việt, sơ đồ quan hệ 8 bảng dạng ASCII, diễn giải từng bước — phục vụ tiêu chí Y3/Y4. **Bổ sung Data Understanding (2026-07-17):** sắp xếp lại mạch notebook thành 9 mục (mục tiêu → bối cảnh → chuẩn bị → bản đồ dữ liệu → bảng trung tâm → bảng phụ/khóa → từ điển → thách thức/phương pháp → tổng kết), thêm checklist 5 ý lớn + 6 câu tự kiểm tra, thêm ERD PNG tại `reports/images/home_credit_erd.png`, format lại bảng overview để số đếm không còn `.0000`. Code cell giữ execution_count 1→14 liền mạch; thay đổi chủ yếu là markdown/output hiển thị.
  - ✅ **Notebook 02 (`02_posgrespl_pipline.ipynb`) — HOÀN THÀNH** (T04, PR #23): pipeline PostgreSQL bằng Python (tạo bảng → import `copy_expert` → view/aggregation/index → validation). **Đã sửa** lỗi env path (`find_dotenv`) và lỗi nạp trùng dữ liệu (thêm `TRUNCATE` cho idempotent) — fix PR #27.
  - ✅ **Notebook 04 (`04_eda_visualization.ipynb`) — HOÀN THÀNH** (T09, PR #24): EDA đơn/đa biến, tương quan, biểu đồ theo `TARGET`. **Đã sửa** đồng bộ env path + bổ sung biểu đồ mục 4 (bureau) + nhận xét — fix PR #28.
  - ✅ **Notebook 03 (`03_data_cleaning.ipynb`) — HOÀN THÀNH** (PR #33/#34): làm sạch `application_train/test` (DAYS_EMPLOYED 365243 → NaN, gộp CODE_GENDER 'XNA', cap thu nhập...), xuất `data/processed/application_*_clean.csv`. **Đã vá 2 lỗi âm thầm** (2026-07-15): (1) pandas 3 bật Copy-on-Write khiến cú pháp `df['cot'].replace(..., inplace=True)` KHÔNG ghi được vào DataFrame gốc → 2 bước làm sạch thất bại mà không báo lỗi, vì `warnings.filterwarnings("ignore")` đã nuốt mất `ChainedAssignmentError`; (2) đã thêm `assert` kiểm chứng sau mỗi bước thay thế để lỗi không thể tái diễn âm thầm.
  - ✅ **Notebook 05 (`05_feature_engineering.ipynb`) — HOÀN THÀNH** (T10, PR #26/#29): tổng hợp đặc trưng từ 5 bảng phụ, biến nghiệp vụ (DTI, ext_source...), One-Hot, StandardScaler (fit trên train, tránh leakage), xuất `data/processed/*.csv` + `models/scaler.pkl`. **Đã vá** `reduce_mem_usage` để chạy được trên pandas 3.0/numpy 2.x.
  - ✅ **NB03 + NB05 đã chạy trên TOÀN BỘ dữ liệu** (2026-07-15): cờ `DEBUG` của cả hai notebook nay **mặc định `False`** — output nhúng trong file là dữ liệu thật (`train_features.csv` 307.511×299, `test_features.csv` 48.744×298, ~1,87 GB + 296 MB, đều đã gitignore). Trước đó NB05 ghi `DEBUG=False` trong code và markdown khẳng định "đã chạy full", nhưng ô cấu hình chưa hề chạy (`execution_count=None`) nên output vẫn là mẫu 15k/5k — kiểu lỗi "chữ nói một đằng, output một nẻo". **Muốn chạy lại:** phải chạy NB03 trước rồi mới tới NB05, và giữ cờ `DEBUG` giống nhau ở cả hai. Máy yếu RAM đặt `DEBUG=True` để chạy thử (đỉnh RAM khi chạy full đo được ~3,3 GB).
  - ✅ **`README.md` + `requirements.txt` — HOÀN THÀNH** (T19, PR #36): README 8 mục (giới thiệu đề tài, cấu trúc, yêu cầu môi trường, cài đặt 4 bước, sơ đồ pipeline 2 nhánh, trạng thái, **các bẫy đã biết**, quy trình nhóm). `requirements.txt`: **bỏ** `sqlalchemy` (đã kiểm chứng không file nào import — nó chỉ xuất hiện trong dòng *cảnh báo* của pandas); **thêm** `ipykernel` (trước đây THIẾU → `pip install -r requirements.txt` xong không mở nổi notebook) và `streamlit` (cho task app/). Đã verify: `pip check` sạch, `pip install --dry-run` exit 0.
  - ✅ **Notebook 06 (`06_machine_learnig.ipynb`) — HOÀN THÀNH** (T11, PR #38 — Thắng): 34 cell (12 cell code), Restart & Run All trên **toàn bộ 307.511 dòng** (`DEBUG=False`, execution_count liền mạch 1→12, 3 biểu đồ nhúng thật). **Đây là mốc gỡ nút thắt lớn nhất của dự án** — `models/model.pkl` từ file rỗng 0 byte nay là model thật 1,0 MB.
    - **Kết quả (61.503 dòng kiểm định):** HistGradientBoosting **AUC-ROC = 0,7792** (được chọn) > Logistic Regression 0,7691 > Random Forest 0,7630 > Dummy 0,5000. Chỉ dùng scikit-learn, **không thêm thư viện nào** vào `requirements.txt`.
    - ✅ Thoả yêu cầu "so sánh HOẶC tối ưu mô hình" (Phần A mục 8) bằng **so sánh 4 mô hình**.
    - 🔴 **Ai làm `app/` hoặc NB07 phải đọc kỹ:** ngưỡng mặc định 0,5 của sklearn **chỉ bắt được 3,24% khách vỡ nợ** → notebook chốt **ngưỡng Youden J = 0,0747** (bắt 73% khách vỡ nợ, đổi lại từ chối oan 17.398 khách tốt). **Đọc `decision_threshold` từ `models/model_metadata.json`, ĐỪNG dùng `.predict()` mặc định.**
    - **Phát hiện dùng được cho báo cáo:** `EXT_SOURCES_MEAN` (biến phái sinh của NB05) quan trọng **gấp 13 lần** biến kế tiếp; **3/7 đặc trưng mạnh nhất đào từ bảng phụ** (installments, POS_CASH) → đúng bằng chứng cho **Phần B** đề bài. Ba mô hình chỉ chênh ~0,016 ⇒ **muốn tăng điểm thì đầu tư thêm đặc trưng, đừng đổi thuật toán**.
    - **Suýt dính lại bẫy cũ:** markdown nháp ghi sẵn "EXT_SOURCE_1/2/3 đứng đầu" nhưng số chạy thật khác hẳn → đã sửa nhận xét theo output thật. Lại một lần nữa: `nbconvert` KHÔNG đụng markdown.
  - ❌ **Còn lại (chưa làm):** notebook `07_prediction_demo` mới có cell tiêu đề; các file trong `app/` (Streamlit) còn rỗng 0 byte.
  - 🟡 **Báo cáo & slide — MỚI BẮT ĐẦU** (cập nhật 2026-07-17): đã có **bản thảo Chương 1 Business Understanding** (`docs/Business_Understanding.docx` — bối cảnh nghiệp vụ Home Credit, lý do chọn dataset, tầm quan trọng trong ngành AI, **SWOT**, vai trò AI hỗ trợ chuyên viên, phát biểu bài toán, ý nghĩa `TARGET`, lý do là phân loại nhị phân) + đã có **bản ghi chú Data Understanding** cho nhóm (`docs/Data_Understanding.docx`: mục tiêu, 5 ý lớn, 6 câu tự kiểm tra) + đã điền **trang bìa mẫu** (`docs/2. Mau tai lieu.docx`: tiêu đề + danh sách 5 thành viên). ⚠️ **Nhưng file NỘP trong `reports/` vẫn là mẫu trắng:** `reports/slide-du-an-nhom-01.pptx` md5 **TRÙNG KHÍT** `docs/3. Mau bao cao.pptx`; `reports/tai-lieu-du-an-nhom-01.docx` còn `<<TÊN ĐỀ TÀI>>` và "GVHD: Thầy Nguyễn Văn A". Còn lại: **Chương 2–6 + slide**, và phải **ghép Chương 1 từ `docs/` sang file nộp `reports/`**. Đây là 2 trong 4 sản phẩm phải nộp (xem mục 2.2) và chiếm trọn tiêu chí Y4.
  - 🔴 **Dashboard interactive — CHƯA CÓ** (phát hiện 2026-07-15): NB04 chỉ dùng `matplotlib` + `seaborn` = **biểu đồ tĩnh**. Đã quét toàn bộ notebook: không có `plotly`/`bokeh`/`altair`/`ipywidgets`. Trong khi Phần A mục 7 của đề bài **bắt buộc** dashboard tương tác (filter, chọn thời gian, nhóm dữ liệu). Xem mục 4.
  - ⚠️ **Bài học chung (2026-07-13):** NB02/04/05 đều dính lỗi kiểu *"chạy được máy tác giả, hỏng máy khác"* — đường dẫn cứng, thiếu thư viện trong `requirements.txt`, và **lệch phiên bản** (pandas 3.0/numpy 2.x vs bản cũ). Đã **ghim phiên bản thư viện** trong `requirements.txt` để cả nhóm chạy giống nhau.
  - 🔴 **Bài học quan trọng (2026-07-15) — lỗi ÂM THẦM nguy hiểm hơn lỗi báo đỏ:** NB03 và NB05 đều từng ở trạng thái *"code/chữ nói một đằng, dữ liệu thật một nẻo"* mà không ai phát hiện. Ba nguyên nhân gốc cần cả nhóm tránh:
    1. **Đừng dùng `warnings.filterwarnings("ignore")` cho TẤT CẢ cảnh báo** — chính nó đã nuốt `ChainedAssignmentError` của pandas 3, khiến bước làm sạch thất bại trong im lặng. Chỉ tắt riêng loại cảnh báo ồn ào (`FutureWarning`, `DeprecationWarning`, `PerformanceWarning`).
    2. **Notebook phải Restart & Run All trước khi commit.** NB05 từng có ô cấu hình `execution_count=None` (chưa chạy) trong khi các ô sau chạy bằng giá trị cũ còn sót trong kernel → output nhúng là dữ liệu mẫu dù code ghi `DEBUG=False`. Kiểm tra nhanh: execution_count phải liền mạch 1,2,3...
    3. **Thêm `assert` kiểm chứng sau mỗi bước biến đổi dữ liệu quan trọng** — để lỗi phải nổ ra thay vì trôi qua. Và nhớ **markdown/nhận xét cũng phải sửa theo** khi đổi code: `nbconvert` chỉ cập nhật output, KHÔNG đụng tới markdown.
    4. **(Bổ sung 2026-07-22, từ NB02) Sai kiểu dữ liệu khi tạo bảng SQL cũng là lỗi âm thầm.** Trong 3 lỗi kiểu dữ liệu phát hiện ở NB02, hai lỗi đầu (`'Y'`/`'N'` và `'0.0'` đưa vào `SMALLINT`) làm `COPY` chết ngay nên dễ thấy. Lỗi thứ ba nguy hiểm hơn hẳn: `bureau.CREDIT_DAY_OVERDUE` khai `TEXT` trong khi dữ liệu 100% là số nguyên 0–2792 — **import vẫn thành công, không một cảnh báo**, nhưng `MAX()` trên `TEXT` so sánh theo bảng chữ cái nên `'9'` được coi là lớn hơn `'2792'`, khiến khách từng trễ hạn 2.792 ngày bị ghi nhận thành 9 ngày.
       - **Cách bắt:** quét **toàn bộ** giá trị thật của mọi cột khai `TEXT` xem cột nào chứa thuần số. Hai lượt kiểm tra trước đó không phát hiện được vì chỉ kiểm "dữ liệu có import lọt hay không".
       - **Cách phòng:** `sql/04_check_column_types.sql` đối chiếu số cột và số cột kiểu chữ của từng bảng với thiết kế, chạy sau mỗi lần import. Cũng cần vì `COPY` ghép dữ liệu **theo vị trí cột chứ không theo tên cột** — thứ tự lệch thì dữ liệu vào nhầm cột mà vẫn báo import thành công.

## 4. Việc tiếp theo (cập nhật 2026-07-22 — sau khi hoàn thành NB02 PR #59 và bổ sung NB01 PR #61)

**Với mọi thành viên trước khi bắt đầu:** đọc `docs/QUY-TRINH-LAM-VIEC.md` và làm theo checklist đầu phiên (pull code mới → **khai báo tên** `echo <tên> > .claude/whoami` + tạo `context/<tên>.md` → tạo/chuyển nhánh, KHÔNG code trên main). Ai đã kéo quy trình mới về nhớ **khởi động lại Claude Code** để nạp hook.

**Khi cần hiểu hướng dẫn của giảng viên:** đọc `docs/huong-dan-giang-vien/README.md` trước, sau đó xem `tai-lieu-tham-chieu.md` và `video-bai-giang.md`. Nếu thầy upload thêm video/file mới, bổ sung tiếp vào cùng thư mục này để AI Agent và thành viên mới không mất ngữ cảnh.

### ⚠️ Đọc trước khi phân công: trạng thái sau reset

Sau đợt reset, nền tảng Business Understanding và Data Understanding đã rõ hơn; NB02 và toàn bộ `sql/` đã dựng lại xong. Phần pipeline còn lại vẫn cần làm lại có chủ đích — không mặc định dùng trạng thái pipeline cũ nếu file notebook/SQL không còn trong repo.

| Sản phẩm phải nộp | Mức hoàn thành |
|---|---|
| Mã nguồn `.ipynb` | 🟡 **NB01 + NB02 xong; NB03–NB07 cần làm lại theo kế hoạch mới** |
| SQL/PostgreSQL | ✅ **Xong — 11 file `sql/01`–`sql/11`, bảng `application_flat` 307.511 × 148 sẵn sàng trong PostgreSQL** |
| **Whitepaper `.docx` 6 chương** | 🟡 **Có bản thảo Business/Data Understanding trong `docs/`; file nộp `reports/` vẫn cần ghép/viết tiếp** |
| **Slide `.pptx`** | 🔴 **0% — md5 trùng khít file mẫu** |
| **Ứng dụng web** | 🔴 **0% — `app/` gồm 4 file 0 byte** |

Cộng thêm **dashboard interactive** (Phần A mục 7) vẫn chưa có và cần được tính vào kế hoạch app/dashboard sau này.

### Thứ tự đề xuất

1. **Lên kế hoạch Data Cleaning/NB03** — bước kế tiếp tự nhiên. Ba lưu ý bắt buộc đọc trước khi làm:
   - **Đọc dữ liệu từ PostgreSQL bằng `pd.read_sql`, KHÔNG đọc lại CSV.** Bảng đầu vào là `application_flat`. Đây là yêu cầu rõ ràng của thầy: sau NB02, toàn bộ NB03–NB07 chỉ đọc từ database.
   - **Nhóm cột `credit_card_*` có 220.606 dòng `NULL` (71,7%)** vì chỉ 86.905 trên 307.511 khách từng có dữ liệu thẻ tín dụng. Đây là **tín hiệu thật** (khách không có thẻ), KHÔNG phải missing value — không được điền median/mean như cột thiếu thông thường. Các nhóm cột summary khác cũng có `NULL` với lý do tương tự.
   - **`AMT_CREDIT_SUM_DEBT` có giá trị âm tới `-4.705.600`** — dư nợ không thể âm, cần quy tắc xử lý riêng cho giá trị sai logic. Ngoài ra các cột tiền lệch phải rất nặng nên cân nhắc biến đổi log.
   - Phạm vi còn lại giữ như cũ: missing values, `DAYS_EMPLOYED = 365243`, `CODE_GENDER = XNA`, outlier tiền tệ, kiểm tra sau xử lý.
2. **Lên lại kế hoạch các notebook còn lại** — NB04–NB07 cần khớp với NB01/NB02 mới, code đơn giản/dễ giải thích, có comment ngắn ở đoạn kỹ thuật, markdown trước code ngắn và nhận xét sau output.
3. **Whitepaper `.docx` + slide `.pptx`** — Business/Data Understanding đã có nền trong `docs/`, nhưng file nộp trong `reports/` vẫn cần ghép và viết tiếp Chương 2–6 + 16 slide.
4. **`app/` Streamlit + dashboard interactive** — vẫn là yêu cầu bắt buộc của đề bài, nhưng nên làm sau khi pipeline clean/features/model mới ổn định. Khi dùng lại model cũ, bắt buộc kiểm tra compatibility với `model_metadata.json`.
5. **Hỏi giảng viên về Jira/Trello** — đề bài đòi "Nhật ký Jira" (Chương 5) + ảnh bảng Kanban (slide 12); nhóm đang dùng Google Sheet. Hỏi sớm, đừng để tới lúc nộp mới biết.

### Hai việc nhỏ đang treo, cần Hưng quyết

- **Có thêm `sqlalchemy` vào `requirements.txt` không?** Checklist của thầy ghi cả `psycopg2` lẫn `SQLAlchemy`, nhưng nhóm đã chốt chỉ dùng `psycopg2` (ghi rõ lý do trong `requirements.txt`: truyền connection `psycopg2` vào `pandas.read_sql` chỉ in cảnh báo, code vẫn chạy đúng). NB02 đã ghi rõ lựa chọn này trong nhận xét mục 8.1 để không bị hiểu là bỏ sót.
- **Hỏi thầy 2 lỗi đánh số trong `docs/Task Checklist for Each Notebook.docx`:** tiêu đề `VI. Khảo sát dữ liệu của bảng phụ aaa` có chữ `aaa` thừa trông như gõ sót; phần NB01 kết thúc bằng `IV. Kết luận` trong khi đáng lẽ là `IX`.

> ✅ Trạng thái thật: NB01 (PR #54, bổ sung PR #61) và NB02 + toàn bộ `sql/` (PR #59) đã xong và merge vào `main`; tài liệu hướng dẫn giảng viên cập nhật theo checklist mới (PR #60); Business Understanding docs merge PR #53; `README.md` + `requirements.txt` vẫn có sẵn. Cần làm lại NB03–NB07 theo kế hoạch mới.

## 5. Ghi chú làm việc

- User trao đổi bằng **tiếng Việt** — trả lời bằng tiếng Việt
- Môi trường: Windows 11, PowerShell, repo git tại `D:\FPT Polytechnic\2026\HK Summer 2026\Block2\Du-an-01\credit-risk-classifier`
- File này (`PROJECT_CONTEXT.md`) = bức tranh tổng, **do nhóm trưởng cập nhật** (thường khi merge PR). Thành viên **đọc**, không sửa — tiến độ cá nhân ghi vào `context/<tên>.md` của mình.
- Khi hoàn thành mốc quan trọng, nhóm trưởng cập nhật lại mục **3. Trạng thái hiện tại** và **4. Việc tiếp theo** trong file này

## 6. Quy ước định dạng notebook (chốt 2026-07-02)

Áp dụng thống nhất cho cả 7 notebook — **mọi phiên làm việc phải tuân theo**:

1. **Cell đầu tiên (Markdown):** tiêu đề dự án (H1 `#`) → dòng `**Notebook XX/07 — Tên EN (Tên tiếng Việt)**` → gạch ngang `---` → các trường: **🎯 Mục tiêu**, **📥 Input**, **📤 Output**, **🔗 Pipeline** (notebook trước → **hiện tại** → notebook sau). Cả 7 notebook đã có sẵn cell này làm mẫu.
2. **Đề mục thân notebook:** mục lớn `## 1.`, `## 2.`, ...; mục con `### 1.1.`, `### 1.2.`, ...; cấp 3 `#### 1.1.1.`, ...; cấp 4 KHÔNG dùng heading mà dùng chữ đậm `**a. ...**`, `**b. ...**`. H1 (`#`) chỉ dành riêng cho tiêu đề notebook ở cell đầu.
   - ⚠️ **SỐ MỤC LỚN KHÔNG CỐ ĐỊNH — KHÔNG có quy định "phải đủ 6 mục".** Chia bao nhiêu mục là **tuỳ nội dung** notebook đó cần. **Đừng nhồi thêm mục cho đủ số, cũng đừng gộp mục lại cho gọn số.** Thực tế trong repo: NB01 có 6 mục, NB02–NB06 có 7 mục — **không notebook nào sai quy ước**.
3. **Nhận xét sau kết quả:** cell code có output mang ý nghĩa phân tích (bảng thống kê, biểu đồ, kết quả đánh giá mô hình...) phải có cell Markdown ngay bên dưới, mở đầu bằng `**Nhận xét:**`. Markdown trước code chỉ viết ngắn gọn để dẫn vào bước chạy, ưu tiên dạng "Đoạn code bên dưới..."; không viết dài kiểu "cell này làm gì/vì sao/output mong đợi". Nếu cần giải thích kỹ thuật, viết comment ngắn ngay trong cell code. Cell kỹ thuật thuần túy (import, config, định nghĩa hàm) không bắt buộc có nhận xét.
4. **Cuối notebook:** mục **Tổng kết** luôn là **mục lớn cuối cùng**, mang **số thứ tự kế tiếp của chính notebook đó** — notebook có 5 mục nội dung thì Tổng kết là `## 6.`, có 6 mục nội dung thì Tổng kết là `## 7.`. Nội dung: chốt các phát hiện chính và nêu bước tiếp theo (dẫn sang notebook kế tiếp).
   - Quy định ở đây là **"Tổng kết đứng cuối"**, KHÔNG phải "Tổng kết là mục số 6". Trong repo: NB01 → `## 6. Tổng kết`, NB02–NB06 → `## 7. Tổng kết`. Cả hai đều đúng.
   - 📌 *Ghi chú lịch sử (làm rõ 2026-07-15):* bản quy ước cũ ghi "*ví dụ `## 6. Tổng kết`*" — con số 6 lấy từ NB01 và **chỉ là ví dụ**, nhưng dễ bị đọc nhầm thành bắt buộc. Nay đã viết lại cho dứt khoát.
