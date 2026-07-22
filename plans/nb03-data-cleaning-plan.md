# Kế hoạch triển khai NB03 — Data Cleaning

> **File này là bản kế hoạch đầy đủ, tự chứa, để một AI Agent (Claude Code / Antigravity / khác) đọc và triển khai `notebooks/03_data_cleaning.ipynb` mà không cần ngữ cảnh cuộc trò chuyện đã sinh ra nó.** Mọi số liệu trong file đã được đo thật từ PostgreSQL ngày 2026-07-22 (bảng `application_flat` do NB02 tạo).
>
> Nguồn checklist gốc của thầy: `docs/Task Checklist for Each Notebook.docx` (phần NOTEBOOK 03) + bản tóm tắt `docs/huong-dan-giang-vien/huong-dan-nb03-data-cleaning-2026-07-22.md`. Khi có mâu thuẫn, checklist gốc của thầy là nguồn sự thật.

---

## 0. Trước khi bắt đầu (quy trình nhóm — BẮT BUỘC)

- Đọc `AGENTS.md` và `PROJECT_CONTEXT.md` (mục 3, 4, 6) trước khi động vào repo.
- **Kiểm tra nhánh:** `git branch --show-current`. KHÔNG code trên `main`. Tạo nhánh `feature/t03-data-cleaning` từ `main` mới nhất (`git pull origin main` rồi `git switch -c feature/t03-data-cleaning`).
- Notebook nộp cho thầy + hội đồng: **giọng kỹ thuật chuyên nghiệp, không nhắc trình độ cá nhân, không nhắc vai trò của AI, không emoji thừa.**
- Commit message tiếng Việt không dấu, dạng `<loại>: <mô tả>` (vd `feature: them notebook 03 data cleaning`).

## 1. Mục tiêu & vai trò NB03

Biến `application_flat` (dữ liệu đã tích hợp từ PostgreSQL ở NB02) thành **dữ liệu sạch, nhất quán, sẵn sàng cho EDA (NB04)**. Thầy định nghĩa "sạch" gồm 4 ý: không còn thiếu, không còn trùng lặp, không sai logic, đủ và rõ nghĩa.

Pipeline thầy yêu cầu:

```
Read SQL -> Missing -> Duplicate -> Outlier -> Logic Validation -> Save Clean Data -> NB04 (EDA)
```

**Yêu cầu về cách trình bày (quan trọng — Hưng nhấn mạnh):** notebook phải viết **như thể người làm tự hiểu và tự làm, không dùng AI**. Với mỗi bước xử lý, trình bày theo mạch:

> **Vấn đề phát hiện → Bằng chứng (số liệu/biểu đồ) → Cách xử lý → Lý do chọn cách đó → Kiểm tra sau xử lý.**

Điểm số của NB03 nằm ở **phần giải trình lý do**, không nằm ở dòng code. Giải thích nghiệp vụ đủ để người đọc (kể cả người yếu code) hiểu được và tự bảo vệ trước hội đồng.

## 2. Thắc mắc của người dùng mà notebook phải giải đáp rõ

1. **"Vì sao NB03 chỉ làm sạch 1 bảng, trong khi NB01 chỉ ra nhiều bảng có vấn đề?"**
   → Notebook phải có một đoạn markdown ở Mục 1 hoặc 2 giải thích: **NB02 đã gom 5 bảng phụ về mức khách hàng (mỗi khách 1 dòng) rồi `LEFT JOIN` thành `application_flat`**. Nên dữ liệu của cả 5 bảng phụ đã nằm trong `application_flat` dưới dạng **nhóm cột** (`bureau_*`, `previous_*`, `installments_*`, `pos_cash_*`, `credit_card_*`). **Làm sạch theo nhóm cột chính là làm sạch theo từng bảng phụ.** Nếu làm sạch từng bảng raw trước rồi mới join thì phải làm lại toàn bộ NB02 — nên hướng "clean sau join" hợp lý hơn. Đây đúng ý thầy trong phần "Nếu dataset có nhiều bảng".
2. **Trung thực về giới hạn của hướng "clean sau join":** một số lỗi ở tầng raw đã bị NB02 tổng hợp (`SUM`/`AVG`) trước khi tới NB03. Ví dụ `AMT_CREDIT_SUM_DEBT` âm ở từng dòng `bureau` đã bị `SUM` thành `bureau_sum_debt`. Notebook cần ghi rõ NB03 chỉ xử lý được **giá trị tổng đã gom**, không xử lý từng dòng raw. Đây là cái giá của kiến trúc đã chọn, cần nêu minh bạch.

## 3. Đầu vào / Đầu ra

- **Đầu vào:** bảng `application_flat` trong PostgreSQL, **307.511 dòng × 148 cột**. Đọc bằng `pd.read_sql()`, **KHÔNG đọc lại CSV** (yêu cầu rõ ràng của thầy, lặp lại từ NB02).
- **Đầu ra:** bảng `application_flat_cleaned` ghi ngược về PostgreSQL. Dự kiến **307.511 dòng × ~120 cột** (xem Mục 6 để biết vì sao giảm cột).

### Kết nối PostgreSQL — cạm bẫy đã gặp, phải tránh

Dùng `psycopg2` + `.env` (giống Mục 8 của NB02, KHÔNG dùng SQLAlchemy — theo ghi chú trong `requirements.txt`). Mẫu kết nối:

```python
import os, psycopg2, pandas as pd
from dotenv import load_dotenv, find_dotenv

# QUAN TRONG: dung usecwd=True. Neu chay dang file .py ngoai repo,
# find_dotenv() mac dinh do tu thu muc chua file -> KHONG thay .env cua repo.
load_dotenv(find_dotenv(usecwd=True), override=True)
conn = psycopg2.connect(
    host=os.getenv("DB_HOST"), port=os.getenv("DB_PORT"),
    dbname=os.getenv("DB_NAME"), user=os.getenv("DB_USER"),
    password=os.getenv("DB_PASSWORD"),
)
df = pd.read_sql("SELECT * FROM application_flat", conn)
```

`.env` có sẵn 5 khóa: `DB_HOST=localhost`, `DB_PORT=5432`, `DB_NAME=credit_risk_db`, `DB_USER=postgres`, `DB_PASSWORD=...`.

## 4. Số liệu thật đã đo từ `application_flat` (ground truth — dùng để giải trình)

**Shape:** 307.511 dòng × 148 cột. **Trùng `sk_id_curr`: 0 dòng.**

**Cấu tạo 148 cột:** 122 cột từ `application_train` + 26 cột summary (bureau 6, previous 5, installments 5, pos_cash 5, credit_card 5).

**a) Giá trị sai logic còn tồn tại:**

| Cột | Vấn đề | Số dòng | Tầng |
|---|---|---|---|
| `code_gender = 'XNA'` | giá trị không hợp lệ | 4 | bảng chính (chưa gom) |
| `days_employed = 365243` | mã đặc biệt (~1000 năm) | 55.374 | bảng chính (chưa gom) |
| `bureau_sum_debt` âm | dư nợ tổng âm, min = −6.981.558 | 1.296 | đã gom (SUM) |
| `credit_card_avg_balance` âm | số dư TB âm, min = −2.930 | 28 | đã gom (AVG) |

Các cột tiền còn lại đều min ≥ 0.

**b) NULL theo nhóm cột summary (dòng khách không có lịch sử bảng phụ — TÍN HIỆU THẬT, không phải missing hỏng):**

| Nhóm cột | Số dòng NULL | Tỷ lệ |
|---|---|---|
| `credit_card_*` | 220.606 | 71,7% |
| `bureau_*` | 44.020 | 14,3% |
| `pos_cash_*` | 18.067 | 5,9% |
| `previous_*` | 16.454 | 5,4% |
| `installments_*` | 15.868 | 5,2% |

**c) Missing tổng thể:** 93/148 cột có missing. Chia mức: **<5%: 10 cột · 5–30%: 28 cột · >30%: 55 cột.**

**d) Tương quan với TARGET của nhóm missing >30%** (mốc: biến mạnh nhất toàn bảng là `ext_source_3` với |corr| = 0,179):

| Nhóm | Số cột | |corr| TB | |corr| max | Ghi chú |
|---|---|---|---|---|
| KHÁC | 3 | 0,096 | **0,155** (`ext_source_1`) | `ext_source_1` mạnh top 3 toàn bảng — GIỮ dù thiếu 56% |
| credit_card | 5 | 0,046 | 0,087 | tín hiệu thật — GIỮ |
| NHÀ Ở | 47 | 0,022 | 0,044 | yếu nhất bảng + trùng lặp `_avg`/`_medi`/`_mode` |

Cột chữ missing cao: `occupation_type` (31,3% — nghề nghiệp, có nghĩa, GIỮ) + 5 cột nhà ở dạng chữ (`housetype_mode`, `emergencystate_mode`, `wallsmaterial_mode`, `fondkapremont_mode`).

**e) Đếm cột nhà ở dạng `_avg`/`_medi`/`_mode`:** 14 cột `_avg`, 14 cột `_medi`, 19 cột `_mode` (trong đó 14 numeric + 5 chữ).

## 5. Các quyết định đã chốt với người dùng

1. **credit_card_* (NULL 71,7%):** là tín hiệu thật (khách không có thẻ), KHÔNG điền median/mean. Cột đếm (`credit_card_count`) điền `0`; thêm một **cột flag** `has_credit_card` đánh dấu khách có/không có lịch sử thẻ. Áp cùng logic cho các nhóm summary khác: `*_count` NULL → `0` + cột flag tương ứng nếu cần.
2. **Giá trị âm sai logic** (`bureau_sum_debt` 1.296 dòng, `credit_card_avg_balance` 28 dòng): xử lý ngay ở NB03 **trên mức tổng đã gom** — đưa giá trị âm về `0` (hoặc `NaN` rồi điền). Ghi rõ trong notebook: gốc đã bị NB02 gom nên chỉ xử được ở mức tổng; số lượng chỉ ~0,43% nên không đáng làm lại NB02.
3. **Nhà ở — loại cột trùng lặp:** mỗi thuộc tính giữ 1 bản `_avg`, **bỏ 14 cột `_medi` + 14 cột `_mode` numeric = 28 cột**. Lý do: 3 bản `_avg`/`_medi`/`_mode` là 3 thống kê (trung bình/trung vị/mode) của cùng một thuộc tính toà nhà, tương quan với TARGET gần như y hệt nhau (vd `floorsmax`: −0,044 / −0,044 / −0,043) → đúng định nghĩa "duplicate column" của thầy. 5 cột nhà ở dạng chữ (`_mode` text) KHÔNG có bản `_avg` nên GIỮ, xử lý như categorical.
4. **Giữ chắc chắn:** `ext_source_1` (corr −0,155, thiếu 56% vẫn giữ vì là biến mạnh — đúng cảnh báo "không xóa chỉ vì thiếu nhiều"), `occupation_type` (điền "Unknown").
5. **Việc chọn/bỏ feature sâu là của NB05**, không phải NB03. NB03 chỉ loại trùng lặp hiển nhiên như điểm 3.

## 6. Cấu trúc notebook chi tiết

Số cột kỳ vọng sau cleaning: 148 − 28 (bỏ `_medi`/`_mode` numeric) + số cột flag thêm ≈ **~120 cột**.

| Mục | Nội dung | Biến đổi DL? | Trực quan Before/After |
|---|---|---|---|
| 1. Giới thiệu | Mục tiêu, vai trò cleaning, sơ đồ pipeline, **giải đáp thắc mắc "vì sao 1 bảng"** (Mục 2 file này) | Không | — |
| 2. Đọc dữ liệu | `pd.read_sql` `application_flat`; kiểm shape (kỳ vọng 307.511 × 148), `head()`, `info()` rút gọn | Không | — |
| 3. Đánh giá chất lượng ban đầu | Chia cột theo **kiểu** (Numeric/Category/ID) và theo **mức missing** (<5% / 5–30% / >30%). Lập bảng để làm nền cho xử lý theo nhóm | Không | Bar tỷ lệ missing các cột thiếu nhiều nhất (ảnh "trước") |
| 4. Xử lý Missing Values | Xử lý **theo nhóm cột**, không từng cột: `*_count` → 0 + flag; numeric <30% → median; category → mode; `credit_card_*`/`ext_source_1`/`occupation_type` theo quyết định Mục 5. Kèm **bảng Cleaning Rule** (nhóm cột → phương pháp → lý do) | ✅ | **Before/After**: bar/heatmap tỷ lệ missing trước vs sau |
| 5. Xử lý Duplicate | Kiểm `sk_id_curr` (thực tế 0 trùng — vẫn chạy kiểm tra để xác nhận, không giả định). **Báo số dòng loại bỏ và còn lại** | Không | Chỉ báo số |
| 6. Xử lý Outlier | Phát hiện bằng **IQR hoặc Z-score** cho cột tiền lệch phải (`amt_income_total`, `amt_credit`, `bureau_sum_credit`...). Xử lý bằng **biến đổi log hoặc cap theo phân vị, KHÔNG xóa dòng** (phần lớn là khách vay lớn có thật). Nêu rõ câu của thầy: "không phải outlier nào cũng nên xóa" | ✅ | **Before/After**: boxplot + histogram cột tiền |
| 7. Xử lý sai logic | `days_employed = 365243` → NaN (rồi điền); `code_gender = 'XNA'` → gộp về nhóm phổ biến ('F'); giá trị âm `bureau_sum_debt`/`credit_card_avg_balance` → 0. Mỗi ca theo mạch Vấn đề→Bằng chứng→Xử lý→Lý do→Kiểm tra | ✅ | **Before/After**: histogram `days_employed` (cột dựng ở 365243 biến mất), bar `code_gender` (XNA gộp đi) |
| 8. Loại cột trùng lặp / không cần thiết | Bỏ 28 cột `_medi`/`_mode` numeric nhà ở (quyết định Mục 5.3). Kiểm cột hằng số (constant) nếu có. Ghi bảng lý do từng nhóm cột bị bỏ | ✅ | Bảng |
| 9. Đánh giá sau cleaning | **Bảng tổng hợp Before/After bắt buộc** gồm các hàng: Rows, Columns, Missing, Duplicate, Outlier, Invalid Values. Đây là câu trả lời cho câu hỏi cốt lõi #3 | Không | Bảng tổng hợp (+ 1 biểu đồ tóm tắt tổng số ô thiếu trước/sau nếu muốn) |
| 10. Lưu dữ liệu | Ghi `application_flat_cleaned` về PostgreSQL (dùng `to_sql` hoặc `COPY`). Xác nhận số dòng = 307.511, `sk_id_curr` không trùng sau khi ghi | — | — |
| 11. Tổng kết | Chốt các phát hiện chính, trả lời 4 câu hỏi cốt lõi, dẫn sang NB04 | — | — |

**Ghi chú quy ước:** số mục KHÔNG cố định — có thể co lại khi viết (vd gộp 7+8). Quy định thật là **mục "Tổng kết" luôn đứng CUỐI, mang số thứ tự kế tiếp của notebook**. Đừng nhồi/gộp mục cho khớp một con số nào.

### Trực quan hóa — nguyên tắc
- **Chỉ vẽ Before/After ở những mục THỰC SỰ biến đổi dữ liệu** (Mục 4, 6, 7). Mục chỉ khảo sát/đánh giá thì không cần cặp biểu đồ. "Xử lý tới đâu trực quan tới đó."
- Viết **một hàm dùng chung** kiểu `plot_before_after(before, after, cot, kind)` để mọi mục gọi lại, tránh copy-paste (tiêu chí Y3). Chụp snapshot dữ liệu trước mỗi bước biến đổi để so.
- Biểu đồ tĩnh matplotlib/seaborn **đủ dùng cho NB03**. Yêu cầu "dashboard interactive" của đề bài là việc riêng của phần `app/`, KHÔNG thuộc NB03.

## 7. Quy ước định dạng notebook (BẮT BUỘC — trích PROJECT_CONTEXT.md mục 6)

1. **Cell đầu (Markdown):** tiêu đề dự án (H1) → dòng `**Notebook 03/07 — Data Cleaning (Làm sạch dữ liệu)**` → `---` → các trường **Mục tiêu / Input / Output / Pipeline** (NB02 → **NB03** → NB04). Cell tiêu đề chuẩn này có thể đã có sẵn khung — kiểm tra trước.
2. **Đề mục:** mục lớn `## 1.`, mục con `### 1.1.`, cấp 3 `#### 1.1.1.`, cấp 4 dùng chữ đậm `**a.**`. H1 chỉ dành cho tiêu đề notebook.
3. **Markdown trước code:** chỉ 1 câu ngắn dẫn vào, ưu tiên dạng "Đoạn code bên dưới...". KHÔNG viết dài kiểu "cell này làm gì / vì sao / output mong đợi". Giải thích kỹ thuật thì viết **comment ngắn trong cell code**.
4. **Markdown sau output:** cell code có output mang ý nghĩa phân tích phải có cell Markdown ngay dưới, mở đầu bằng `**Nhận xét:**`. Cell kỹ thuật thuần (import/config/định nghĩa hàm) không bắt buộc.

## 8. Nguyên tắc kỹ thuật — 3 bẫy đã từng làm hỏng NB03 cũ, PHẢI tránh

1. **pandas 3 bật Copy-on-Write:** `df['cot'].replace(..., inplace=True)` KHÔNG ghi được vào DataFrame gốc → dùng **phép gán tường minh** (`df['cot'] = df['cot'].replace(...)` hoặc `.loc[...]`). Bản NB03 cũ từng thất bại âm thầm đúng ở `days_employed=365243` và `code_gender=XNA`.
2. **KHÔNG dùng `warnings.filterwarnings("ignore")` toàn cục** — chính nó đã nuốt `ChainedAssignmentError` khiến lỗi trên không lộ ra. Chỉ tắt riêng loại ồn ào (`FutureWarning`, `DeprecationWarning`, `PerformanceWarning`), hoặc tắt cảnh báo "SQLAlchemy" của `pd.read_sql`.
3. **Thêm `assert` sau mỗi bước biến đổi quan trọng** để lỗi phải nổ thay vì trôi (vd sau khi thay 365243: `assert (df['days_employed'] == 365243).sum() == 0`). **Restart & Run All bằng nbconvert trước khi commit**, kiểm `execution_count` liền mạch 1,2,3... **Markdown/nhận xét phải sửa theo khi đổi code** — `nbconvert` chỉ cập nhật output, không đụng markdown.

## 9. Bốn câu hỏi cốt lõi notebook phải trả lời (thầy chấm theo đây)

1. Dữ liệu đang gặp những vấn đề gì? (Missing, Duplicate, kiểu dữ liệu, giá trị không hợp lệ, Outlier, lỗi nghiệp vụ)
2. Nhóm đã xử lý từng vấn đề bằng phương pháp nào và **vì sao** chọn phương pháp đó? (bảng Cleaning Rule)
3. Chất lượng dữ liệu đã thay đổi thế nào sau khi làm sạch? (bảng Before/After ở Mục 9)
4. Dữ liệu đã sẵn sàng cho EDA và Feature Engineering chưa?

## 10. Cách kiểm chứng khi hoàn thành

- `Restart & Run All` bằng nbconvert, **0 cell lỗi, execution_count liền mạch**.
- Bảng `application_flat_cleaned` trong PostgreSQL: **đúng 307.511 dòng**, `sk_id_curr` không trùng (kiểm tính nhất quán sau cleaning theo ý thầy "join thử lại xem có mất dữ liệu không").
- Số cột và số ô NULL sau cleaning khớp bảng Cleaning Rule và bảng Before/After.
- `assert` sau các bước sai-logic đều pass (không còn 365243, XNA, giá trị âm).
- Không còn `filterwarnings("ignore")` toàn cục; không còn chained `inplace=True`.

## 11. Checklist bàn giao

- [ ] Tạo nhánh `feature/t03-data-cleaning` từ `main` mới nhất.
- [ ] Viết `notebooks/03_data_cleaning.ipynb` theo cấu trúc Mục 6, đúng quy ước Mục 7, tránh 3 bẫy Mục 8.
- [ ] Có Before/After ở Mục 4, 6, 7 qua hàm dùng chung.
- [ ] Có bảng Cleaning Rule (Mục 4) và bảng Before/After (Mục 9).
- [ ] Ghi `application_flat_cleaned` về PostgreSQL (Mục 10).
- [ ] Restart & Run All sạch, execution_count liền mạch.
- [ ] Kiểm chứng theo Mục 10.
- [ ] Cập nhật `context/<tên>.md` của người làm; commit trong nhánh; tạo PR để nhóm trưởng review.
