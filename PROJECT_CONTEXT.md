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

1. **Notebooks** (`notebooks/`) — pipeline **KHÔNG phải đường thẳng 01→07**, mà là **2 nhánh độc lập** (xem `README.md` mục 5):
   - **Nhánh CSV** (không cần PostgreSQL): `01_data_understanding` → `03_data_cleaning` → `05_feature_engineering` → `06_machine_learnig` → `07_prediction_demo`
   - **Nhánh Database** (cần PostgreSQL): `02_posgrespl_pipline` → `04_eda_visualization`
   - ⚠️ Hệ quả: **người làm NB06 KHÔNG cần cài PostgreSQL** — chỉ cần chạy NB03 → NB05.
2. **SQL** (`sql/`, PostgreSQL): `01_create_tables.sql` → `02_import_data.sql` → `03_views.sql` → `04_aggregation.sql` → `05_indexes.sql`
3. **App** (`app/`): demo bằng **Streamlit** (`stream_app.py`, `pages/`, `prediction.py`) + có thể thêm API (`api.py`)
4. **Models** (`models/`): `model.pkl` (từ NB06) + `scaler.pkl` (từ NB05)
5. **Báo cáo** (`reports/`): Word + PowerPoint theo mẫu trường; theo dõi tiến độ nhóm bằng **Google Sheet** (nhóm trưởng quản lý, link ở nhóm chat — không nằm trong repo). ⚠️ Đề bài nhắc tới **Jira/Trello + ảnh bảng Kanban** (Chương 5 + slide 12) — cần hỏi giảng viên xem Google Sheet có được chấp nhận thay thế không.

## 3. Trạng thái hiện tại (cập nhật 2026-07-15)

- ✅ Đã dựng xong cấu trúc thư mục hoàn chỉnh
- ✅ Đã tải đầy đủ dữ liệu Home Credit vào `data/raw/`
- ✅ Có tài liệu môn học trong `docs/` (assignment, mẫu tài liệu, mẫu báo cáo)
- ✅ Đã chốt **quy ước định dạng notebook** (xem mục 6) và tạo cell tiêu đề chuẩn cho cả 7 notebook
- ✅ Đã thiết lập **quy trình làm việc nhóm qua git** — gồm nhiều lớp:
  - **GitHub Ruleset**: `protect-main` (cấm push thẳng, bắt buộc PR, chặn force-push/xóa nhánh) + `chi-co-nhom-truong-duoc-merge` (chỉ nhóm trưởng merge được vào main)
  - **Hook Claude Code** (`.claude/settings.json` + `.claude/hooks/`): (1) đầu phiên tự fetch, nhắc pull, **chào theo tên + nhắc file context**; (2) chặn commit/push/merge trên main; (3) **chặn cả thao tác sửa file trên main** (`edit-branch-guard.sh`) — kể cả khi tự đổi về main mà Claude chưa biết
  - **Tài liệu**: `docs/QUY-TRINH-LAM-VIEC.md` (quy trình chi tiết + Phần 0 quyền đổi cấu trúc + Phần 6 context cá nhân) + `CLAUDE.md` (quy tắc cho Claude)
- ✅ **Nội quy (2026-07-03)**: chỉ **nhóm trưởng (Hưng)** được thay đổi cấu trúc thư mục / quy trình / quy định (Phần 0 quy trình)
- ✅ **Context cá nhân (2026-07-03)**: mỗi thành viên có 1 file `context/<tên>.md` (chỉ chủ nhân sửa → hết conflict); khai báo tên đầu phiên qua `.claude/whoami` (không commit). `PROJECT_CONTEXT.md` từ nay do **nhóm trưởng làm chủ** (bức tranh tổng)
- 🔄 **Triển khai nội dung code** (cập nhật 2026-07-13):
  - ✅ **Toàn bộ 5 script SQL — HOÀN THÀNH**: `01_create_tables.sql` (T02, PR #15 — schema 8 bảng, tối ưu kiểu số); `02_import_data.sql` (T03, PR #16/#17 — import CSV bằng `COPY`, ghi chú đổi đường dẫn từng máy); `03_views.sql` (T05, PR #19 — 7 view làm sạch + chỉ số nghiệp vụ CIC/dư nợ/trễ hạn/dùng thẻ); `04_aggregation.sql` (kèm pipeline T04, PR #23 — 3 materialized view tổng hợp installments/pos_cash/credit_card theo khách hàng, có unique index); `05_indexes.sql` (T07, PR #25 — index khóa ngoại + composite/partial cho bureau_balance & target).
  - ✅ **Notebook 01 (`01_data_understanding.ipynb`) — HOÀN THÀNH** (T01, PR #12): 32 cell; tổng quan 8 bảng, phân tích `application_train` (307.511×122, `TARGET` ~8%, 67 cột thiếu), quan hệ khóa, từ điển dữ liệu.
  - ✅ **Notebook 02 (`02_posgrespl_pipline.ipynb`) — HOÀN THÀNH** (T04, PR #23): pipeline PostgreSQL bằng Python (tạo bảng → import `copy_expert` → view/aggregation/index → validation). **Đã sửa** lỗi env path (`find_dotenv`) và lỗi nạp trùng dữ liệu (thêm `TRUNCATE` cho idempotent) — fix PR #27.
  - ✅ **Notebook 04 (`04_eda_visualization.ipynb`) — HOÀN THÀNH** (T09, PR #24): EDA đơn/đa biến, tương quan, biểu đồ theo `TARGET`. **Đã sửa** đồng bộ env path + bổ sung biểu đồ mục 4 (bureau) + nhận xét — fix PR #28.
  - ✅ **Notebook 03 (`03_data_cleaning.ipynb`) — HOÀN THÀNH** (PR #33/#34): làm sạch `application_train/test` (DAYS_EMPLOYED 365243 → NaN, gộp CODE_GENDER 'XNA', cap thu nhập...), xuất `data/processed/application_*_clean.csv`. **Đã vá 2 lỗi âm thầm** (2026-07-15): (1) pandas 3 bật Copy-on-Write khiến cú pháp `df['cot'].replace(..., inplace=True)` KHÔNG ghi được vào DataFrame gốc → 2 bước làm sạch thất bại mà không báo lỗi, vì `warnings.filterwarnings("ignore")` đã nuốt mất `ChainedAssignmentError`; (2) đã thêm `assert` kiểm chứng sau mỗi bước thay thế để lỗi không thể tái diễn âm thầm.
  - ✅ **Notebook 05 (`05_feature_engineering.ipynb`) — HOÀN THÀNH** (T10, PR #26/#29): tổng hợp đặc trưng từ 5 bảng phụ, biến nghiệp vụ (DTI, ext_source...), One-Hot, StandardScaler (fit trên train, tránh leakage), xuất `data/processed/*.csv` + `models/scaler.pkl`. **Đã vá** `reduce_mem_usage` để chạy được trên pandas 3.0/numpy 2.x.
  - ✅ **NB03 + NB05 đã chạy trên TOÀN BỘ dữ liệu** (2026-07-15): cờ `DEBUG` của cả hai notebook nay **mặc định `False`** — output nhúng trong file là dữ liệu thật (`train_features.csv` 307.511×299, `test_features.csv` 48.744×298, ~1,87 GB + 296 MB, đều đã gitignore). Trước đó NB05 ghi `DEBUG=False` trong code và markdown khẳng định "đã chạy full", nhưng ô cấu hình chưa hề chạy (`execution_count=None`) nên output vẫn là mẫu 15k/5k — kiểu lỗi "chữ nói một đằng, output một nẻo". **Muốn chạy lại:** phải chạy NB03 trước rồi mới tới NB05, và giữ cờ `DEBUG` giống nhau ở cả hai. Máy yếu RAM đặt `DEBUG=True` để chạy thử (đỉnh RAM khi chạy full đo được ~3,3 GB).
  - ✅ **`README.md` + `requirements.txt` — HOÀN THÀNH** (T19, PR #36): README 8 mục (giới thiệu đề tài, cấu trúc, yêu cầu môi trường, cài đặt 4 bước, sơ đồ pipeline 2 nhánh, trạng thái, **các bẫy đã biết**, quy trình nhóm). `requirements.txt`: **bỏ** `sqlalchemy` (đã kiểm chứng không file nào import — nó chỉ xuất hiện trong dòng *cảnh báo* của pandas); **thêm** `ipykernel` (trước đây THIẾU → `pip install -r requirements.txt` xong không mở nổi notebook) và `streamlit` (cho task app/). Đã verify: `pip check` sạch, `pip install --dry-run` exit 0.
  - ❌ **Còn lại (chưa làm):** notebook `06_machine_learnig`, `07_prediction_demo` mới có cell tiêu đề; các file trong `app/` (Streamlit) còn rỗng; `models/model.pkl` hiện là **file rỗng 0 byte** (placeholder — chưa train mô hình nào; mới có `scaler.pkl` thật do NB05 sinh, cả hai đã gitignore).
  - 🔴 **Báo cáo & slide — CHƯA BẮT ĐẦU, vẫn là file mẫu trắng** (phát hiện 2026-07-15): `reports/slide-du-an-nhom-01.pptx` có **md5 TRÙNG KHÍT** `docs/3. Mau bao cao.pptx` → bản copy chưa sửa một chữ. `reports/tai-lieu-du-an-nhom-01.docx` vẫn còn `<<TÊN ĐỀ TÀI>>` và "GVHD: Thầy Nguyễn Văn A". `reports/images/` rỗng. **Đây là 2 trong 4 sản phẩm phải nộp** (xem mục 2.2) và chiếm trọn tiêu chí Y4.
  - 🔴 **Dashboard interactive — CHƯA CÓ** (phát hiện 2026-07-15): NB04 chỉ dùng `matplotlib` + `seaborn` = **biểu đồ tĩnh**. Đã quét toàn bộ notebook: không có `plotly`/`bokeh`/`altair`/`ipywidgets`. Trong khi Phần A mục 7 của đề bài **bắt buộc** dashboard tương tác (filter, chọn thời gian, nhóm dữ liệu). Xem mục 4.
  - ⚠️ **Bài học chung (2026-07-13):** NB02/04/05 đều dính lỗi kiểu *"chạy được máy tác giả, hỏng máy khác"* — đường dẫn cứng, thiếu thư viện trong `requirements.txt`, và **lệch phiên bản** (pandas 3.0/numpy 2.x vs bản cũ). Đã **ghim phiên bản thư viện** trong `requirements.txt` để cả nhóm chạy giống nhau.
  - 🔴 **Bài học quan trọng (2026-07-15) — lỗi ÂM THẦM nguy hiểm hơn lỗi báo đỏ:** NB03 và NB05 đều từng ở trạng thái *"code/chữ nói một đằng, dữ liệu thật một nẻo"* mà không ai phát hiện. Ba nguyên nhân gốc cần cả nhóm tránh:
    1. **Đừng dùng `warnings.filterwarnings("ignore")` cho TẤT CẢ cảnh báo** — chính nó đã nuốt `ChainedAssignmentError` của pandas 3, khiến bước làm sạch thất bại trong im lặng. Chỉ tắt riêng loại cảnh báo ồn ào (`FutureWarning`, `DeprecationWarning`, `PerformanceWarning`).
    2. **Notebook phải Restart & Run All trước khi commit.** NB05 từng có ô cấu hình `execution_count=None` (chưa chạy) trong khi các ô sau chạy bằng giá trị cũ còn sót trong kernel → output nhúng là dữ liệu mẫu dù code ghi `DEBUG=False`. Kiểm tra nhanh: execution_count phải liền mạch 1,2,3...
    3. **Thêm `assert` kiểm chứng sau mỗi bước biến đổi dữ liệu quan trọng** — để lỗi phải nổ ra thay vì trôi qua. Và nhớ **markdown/nhận xét cũng phải sửa theo** khi đổi code: `nbconvert` chỉ cập nhật output, KHÔNG đụng tới markdown.

## 4. Việc tiếp theo (cập nhật 2026-07-15 sau khi rà soát lại đề bài gốc)

**Với mọi thành viên trước khi bắt đầu:** đọc `docs/QUY-TRINH-LAM-VIEC.md` và làm theo checklist đầu phiên (pull code mới → **khai báo tên** `echo <tên> > .claude/whoami` + tạo `context/<tên>.md` → tạo/chuyển nhánh, KHÔNG code trên main). Ai đã kéo quy trình mới về nhớ **khởi động lại Claude Code** để nạp hook.

### ⚠️ Đọc trước khi phân công: rủi ro lớn nhất KHÔNG phải NB06

Rà soát lại đề bài gốc ngày 2026-07-15 cho thấy bức tranh khác với hình dung trước đây. **Phần code đang là mảng KHOẺ nhất** của dự án (5/7 notebook + toàn bộ SQL đã xong, dữ liệu đặc trưng đầy đủ đã sẵn sàng). Ngược lại, **3 trong 4 sản phẩm phải nộp đang ở mức 0%**:

| Sản phẩm phải nộp | Mức hoàn thành |
|---|---|
| Mã nguồn `.ipynb` | 🟡 ~70% (thiếu NB06, NB07) |
| **Whitepaper `.docx` 6 chương** | 🔴 **0% — vẫn là file mẫu trắng** |
| **Slide `.pptx`** | 🔴 **0% — md5 trùng khít file mẫu** |
| **Ứng dụng web** | 🔴 **0% — `app/` gồm 4 file 0 byte** |

Cộng thêm **dashboard interactive** (Phần A mục 7) hiện chưa có và trước nay chưa ai nhận ra là yêu cầu bắt buộc.

### Thứ tự đề xuất

1. **Notebook `06_machine_learnig.ipynb`** — mở đường cho mọi thứ còn lại (app cần `model.pkl`, báo cáo cần số liệu thật). Đọc `data/processed/train_features.csv` (sẵn sàng: 307.511×299), train, đánh giá, lưu `models/model.pkl`.
   - ⚠️ `TARGET` mất cân bằng ~8% → **dùng AUC-ROC, KHÔNG dùng accuracy** (đoán bừa "không vỡ nợ" đã được ~92% accuracy nhưng mô hình vô dụng). Cân nhắc `class_weight` / SMOTE.
   - ⚠️ Đề bài (Phần A mục 8) đòi **"có so sánh HOẶC tối ưu mô hình"** → không được train đúng 1 model rồi thôi.
   - ⚠️ Không cần cài PostgreSQL cho task này (xem mục 2.6). File train 1,87 GB → cân nhắc chuyển parquet (`pyarrow` đã có sẵn nhờ streamlit).
2. **`app/` (Streamlit) + dashboard interactive** — **gộp 2 yêu cầu vào 1 task**: mục 9 (ứng dụng web nhập liệu → dự đoán) và mục 7 (dashboard tương tác có filter). Streamlit vốn tương tác sẵn, và đã kéo theo `altair` + `pyarrow` khi cài → không cần thêm thư viện nào.
3. **Notebook `07_prediction_demo.ipynb`** — demo dự đoán, nạp `model.pkl` + `scaler.pkl`.
4. **Whitepaper `.docx` (6 chương) + slide `.pptx`** — làm sau cùng vì lúc đó mới có số liệu thật. Nhưng **phải bắt đầu sớm hơn cảm giác**: 6 chương + 16 slide là khối lượng lớn, và nhóm đang ở 0%. Có thể viết song song Chương 1/2/3/5 ngay từ bây giờ (không phụ thuộc NB06).
5. **Chốt "3 Insights quan trọng"** (tiêu chí Y1) — NB04 có phân tích nhưng nhóm chưa chốt đâu là 3 insight chính thức để đưa vào báo cáo/slide.
6. **Hỏi giảng viên về Jira/Trello** — đề bài đòi "Nhật ký Jira" (Chương 5) + ảnh bảng Kanban (slide 12); nhóm đang dùng Google Sheet. Hỏi sớm, đừng để tới lúc nộp mới biết.

> ✅ Đã xong: Notebook 01 (T01, PR #12), 02 (T04, PR #23 + fix #27), 03 (PR #33/#34 + fix Copy-on-Write), 04 (T09, PR #24 + fix #28), 05 (T10, PR #26/#29 — đã chạy full data); toàn bộ SQL 01–05 (T02/T03/T05/T04/T07); `README.md` + `requirements.txt` (T19, PR #36).

## 5. Ghi chú làm việc

- User trao đổi bằng **tiếng Việt** — trả lời bằng tiếng Việt
- Môi trường: Windows 11, PowerShell, repo git tại `D:\FPT Polytechnic\2026\HK Summer 2026\Block2\Du-an-01\credit-risk-classifier`
- File này (`PROJECT_CONTEXT.md`) = bức tranh tổng, **do nhóm trưởng cập nhật** (thường khi merge PR). Thành viên **đọc**, không sửa — tiến độ cá nhân ghi vào `context/<tên>.md` của mình.
- Khi hoàn thành mốc quan trọng, nhóm trưởng cập nhật lại mục **3. Trạng thái hiện tại** và **4. Việc tiếp theo** trong file này

## 6. Quy ước định dạng notebook (chốt 2026-07-02)

Áp dụng thống nhất cho cả 7 notebook — **mọi phiên làm việc phải tuân theo**:

1. **Cell đầu tiên (Markdown):** tiêu đề dự án (H1 `#`) → dòng `**Notebook XX/07 — Tên EN (Tên tiếng Việt)**` → gạch ngang `---` → các trường: **🎯 Mục tiêu**, **📥 Input**, **📤 Output**, **🔗 Pipeline** (notebook trước → **hiện tại** → notebook sau). Cả 7 notebook đã có sẵn cell này làm mẫu.
2. **Đề mục thân notebook:** mục lớn `## 1.`, `## 2.`, ...; mục con `### 1.1.`, `### 1.2.`, ...; cấp 3 `#### 1.1.1.`, ...; cấp 4 KHÔNG dùng heading mà dùng chữ đậm `**a. ...**`, `**b. ...**`. H1 (`#`) chỉ dành riêng cho tiêu đề notebook ở cell đầu.
3. **Nhận xét sau kết quả:** cell code có output mang ý nghĩa phân tích (bảng thống kê, biểu đồ, kết quả đánh giá mô hình...) phải có cell Markdown ngay bên dưới, mở đầu bằng `**Nhận xét:**`. Cell kỹ thuật thuần túy (import, config, định nghĩa hàm) không bắt buộc nhận xét — chỉ cần một dòng Markdown dẫn dắt phía trên nhóm cell đó.
4. **Cuối notebook:** mục **Tổng kết** (mang số thứ tự cuối cùng, ví dụ `## 6. Tổng kết`) chốt các phát hiện chính và nêu bước tiếp theo (dẫn sang notebook kế tiếp).
