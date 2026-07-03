# QUY TRÌNH LÀM VIỆC NHÓM — credit-risk-classifier

> **Áp dụng bắt buộc cho mọi thành viên.** Quy trình này được hỗ trợ bởi 3 lớp bảo vệ tự động
> (xem [phần cuối](#các-lớp-bảo-vệ-tự-động)), nhưng mỗi người vẫn cần thuộc nhịp làm việc dưới đây.

## 4 quy tắc vàng

1. **KHÔNG BAO GIỜ code trực tiếp trên nhánh `main`** — luôn làm trên nhánh riêng.
2. **Luôn pull code mới nhất TRƯỚC KHI bắt đầu làm việc.**
3. **Mọi thay đổi vào `main` phải đi qua Pull Request** và được 1 thành viên khác approve.
4. **KHÔNG tự ý thay đổi cấu trúc thư mục, quy trình hay quy định của nhóm** — chỉ **nhóm trưởng** mới có quyền quyết định (xem [Phần 0](#phần-0--quyền-thay-đổi-cấu-trúc--quy-định)).

---

## PHẦN 0 — Quyền thay đổi cấu trúc & quy định

> **Nhóm trưởng: Hùng.** Chỉ nhóm trưởng mới được quyết định thay đổi những thứ mang tính "khung xương" của dự án.

**Thuộc phạm vi CHỈ nhóm trưởng được đổi:**

- **Cấu trúc thư mục** — tạo/xóa/đổi tên/di chuyển các folder gốc (`notebooks/`, `sql/`, `app/`, `models/`, `data/`, `reports/`, `docs/`...) và cách tổ chức file bên trong đã chốt.
- **Quy trình làm việc** — các bước trong chính tài liệu này (checklist đầu phiên, cách tạo/review/merge PR, quy ước tên nhánh/commit...).
- **Quy định & cấu hình nhóm** — `CLAUDE.md`, các hook trong `.claude/`, GitHub Ruleset, quy ước định dạng notebook (mục 6 của `PROJECT_CONTEXT.md`).

**Thành viên vẫn tự do làm (không cần xin phép):** viết nội dung code/notebook/SQL/app **bên trong** cấu trúc đã có, thêm file mới **đúng chỗ** theo quy ước, sửa lỗi, viết báo cáo.

**Nếu bạn thấy cần đổi một thứ thuộc phạm vi trên:** đừng tự sửa. Đề xuất với nhóm trưởng (nhắn nhóm hoặc mở một *issue*/PR để thảo luận). Nhóm trưởng đồng ý thì mới thực hiện. Điều này giúp cả nhóm luôn làm trên một khung thống nhất, tránh mỗi người một kiểu gây rối và conflict.

---

## PHẦN 1 — Checklist đầu phiên (mỗi lần mở dự án, ~2 phút)

### Bước 1: Mở Claude Code trong folder dự án

Hook tự động sẽ chạy và báo ngay: bạn đang ở nhánh nào, có bị chậm hơn code trên GitHub không.

### Bước 2: Lấy code mới nhất về

```bash
git switch main
git pull
```

### Bước 3: Nắm ngữ cảnh và xác định task của mình

1. **Đọc `PROJECT_CONTEXT.md`** — tập trung mục **3. Trạng thái hiện tại** và **4. Việc tiếp theo** để biết dự án đang đến đâu, người trước vừa làm gì. Làm việc với Claude thì chỉ cần gõ:
   > *"Đọc file PROJECT_CONTEXT.md để nắm ngữ cảnh dự án, sau đó tiếp tục làm việc với tôi."*
2. Xem phân công trong `Task_Tracker.xlsx` hoặc kênh chat nhóm. Biết task rồi mới biết cần nhánh nào.

### Bước 4: Vào đúng nhánh làm việc

**Trường hợp A — Tiếp tục task đang làm dở:**

```bash
git switch feature/<tên-task>       # chuyển về nhánh cũ
git pull --rebase origin main       # cập nhật code mới nhất từ main vào nhánh
```

**Trường hợp B — Bắt đầu task mới:**

```bash
git switch -c feature/<tên-task>    # tạo nhánh mới từ main (vừa pull ở bước 2)
```

**Quy ước đặt tên nhánh:**

Công thức chung:

```
<tiền-tố>/<mô-tả-ngắn-gọn>
```

- Viết **tiếng Việt không dấu, chữ thường, nối bằng dấu gạch ngang** (`-`).
- Nếu task có mã trong `Task_Tracker.xlsx` (T01, T02...) thì đưa mã vào đầu mô tả — nhìn tên nhánh biết ngay task nào: `feature/t05-feature-engineering`.

| Tiền tố | Dùng khi | Ví dụ |
|---|---|---|
| `feature/` | Làm tính năng, phân tích, model mới | `feature/xu-ly-missing-values` |
| `fix/` | Sửa lỗi | `fix/loi-doc-file-csv` |
| `docs/` | Viết tài liệu, báo cáo | `docs/bao-cao-eda` |

**Ví dụ đặt tên cho từng mảng của dự án này** (nhìn là bắt chước được):

| Mảng việc | Tên nhánh mẫu |
|---|---|
| Notebook 01 — tìm hiểu dữ liệu | `feature/notebook-01-data-understanding` |
| Notebook 04 — EDA & trực quan hóa | `feature/notebook-04-eda` |
| Notebook 06 — huấn luyện model | `feature/notebook-06-machine-learning` |
| SQL — tạo bảng + import dữ liệu | `feature/sql-tao-bang-import` |
| App Streamlit — trang dự đoán | `feature/app-trang-du-doan` |
| Sửa lỗi đường dẫn đọc file CSV | `fix/loi-duong-dan-csv` |
| Báo cáo Word — chương 2 | `docs/bao-cao-chuong-2` |
| Slide bảo vệ | `docs/slide-bao-ve` |

**Các lỗi đặt tên cần tránh:**

| ❌ Tên sai | Vì sao sai | ✅ Sửa thành |
|---|---|---|
| `feature/Xử lý dữ liệu` | Có dấu + khoảng trắng → gõ lệnh git sẽ lỗi | `feature/xu-ly-du-lieu` |
| `feature/update`, `feature/lam-tiep` | Chung chung, không ai biết nhánh làm gì | `feature/notebook-03-data-cleaning` |
| `nhanh-cua-hung` | Nhánh theo NGƯỜI, sống lâu, trôi xa khỏi main → conflict lớn | Nhánh theo TASK, merge xong là xóa |
| `feature/eda-va-sql-va-readme` | Một nhánh ôm nhiều task → PR to, khó review | Tách mỗi task một nhánh riêng |

### Bước 5: Kiểm tra lại lần cuối rồi bắt đầu code

```bash
git branch --show-current
```

Nếu kết quả **không phải** `main` → OK, bắt đầu làm việc. Nếu là `main` → quay lại Bước 4.

---

## PHẦN 2 — Trong khi làm việc

- **Commit nhỏ, thường xuyên** — xong một phần việc trọn vẹn là commit ngay, đừng dồn cả ngày vào 1 commit:

```bash
git add <file-đã-sửa>
git commit -m "feat: them buoc xu ly missing values"
```

- **Quy ước commit message**: `<loại>: <mô tả ngắn>`, tiếng Việt không dấu.

| Loại | Ý nghĩa | Ví dụ |
|---|---|---|
| `feat` | Thêm tính năng/phân tích mới | `feat: them bieu do phan phoi thu nhap` |
| `fix` | Sửa lỗi | `fix: sua loi chia cho 0 khi tinh ty le` |
| `docs` | Tài liệu, comment, notebook markdown | `docs: viet phan ket luan EDA` |
| `chore` | Việc lặt vặt (cấu hình, dọn dẹp) | `chore: cap nhat requirements.txt` |

- Làm việc lâu (nửa ngày trở lên) thì thỉnh thoảng chạy `git fetch origin` xem main có gì mới, có thì `git pull --rebase origin main` để cập nhật sớm — càng để lâu conflict càng to.

---

## PHẦN 3 — Hoàn thành task: đưa code lên GitHub

### Bước 1: Đồng bộ với main lần cuối

```bash
git pull --rebase origin main
```

Nếu có **conflict** (xung đột) → xem [Phần 5](#phần-5--xử-lý-tình-huống-thường-gặp). Giải quyết xung đột ngay trên máy mình, đừng để lên PR.

### Bước 2: Cập nhật file ngữ cảnh `PROJECT_CONTEXT.md`

Nếu task vừa xong là một mốc đáng kể (hoàn thành một notebook, một mảng SQL, một trang app...), cập nhật mục **3. Trạng thái hiện tại** và **4. Việc tiếp theo** trong `PROJECT_CONTEXT.md` rồi commit **ngay trong nhánh này** — thay đổi sẽ đi cùng PR của task, không cần tạo PR riêng:

```bash
git add PROJECT_CONTEXT.md
git commit -m "docs: cap nhat trang thai sau khi xong <tên-task>"
```

- Viết ngắn gọn 1–2 dòng mỗi mục: đã xong gì, người sau nên làm gì tiếp.
- Nhờ Claude làm giúp cũng được: *"Cập nhật PROJECT_CONTEXT.md theo những gì vừa làm xong."*
- Nếu pull về bị conflict ở file này (2 người cùng cập nhật): giữ **cả hai** phần nội dung, gộp các gạch đầu dòng lại.

### Bước 3: Push nhánh lên GitHub

```bash
git push -u origin feature/<tên-task>
```

### Bước 4: Tạo Pull Request (PR)

1. Mở repo trên GitHub — thường sẽ thấy ngay khung vàng **"feature/... had recent pushes"** → bấm nút **Compare & pull request**.
   (Không thấy thì vào tab **Pull requests** → **New pull request** → chọn nhánh của bạn ở ô `compare`.)
2. Kiểm tra hướng gộp: `base: main` ← `compare: feature/<tên-task>`.
3. **Tiêu đề PR**: viết ngắn gọn nội dung task (vd: *"Xử lý missing values cho bộ dữ liệu train"*).
4. **Phần mô tả**: viết 2–4 dòng — đã làm gì, file nào thay đổi chính, có gì cần người review chú ý.
5. Bấm **Create pull request**.
6. **Nhắn vào nhóm** kèm link PR, nhờ một bạn review.

### Bước 5: Nhờ thành viên khác review (khuyến khích, không bắt buộc)

> GitHub không bắt buộc approve để merge — người quyết định cuối cùng là nhóm trưởng ở Bước 6. Nhưng **rất nên** nhờ một bạn review chéo: người viết thường không thấy lỗi của mình, và review giúp cả nhóm hiểu code của nhau (có lợi khi bảo vệ đồ án).

Người review làm 4 bước:

1. Mở link PR → bấm tab **Files changed** — xem các dòng thay đổi (xanh = thêm, đỏ = xóa).
2. Đọc lướt qua: code có chạy đúng ý mô tả không, có xóa nhầm gì của người khác không. Thắc mắc chỗ nào thì rê chuột vào dòng đó, bấm dấu **+** để viết bình luận.
3. Bấm nút **Review changes** (góc trên bên phải).
4. Chọn **✅ Approve** → **Submit review**.
   (Nếu thấy có vấn đề cần sửa thì chọn **Request changes** thay vì Approve — người tạo PR sửa xong, push tiếp lên cùng nhánh, PR tự cập nhật, rồi review lại.)

### Bước 6: Nhóm trưởng merge và dọn dẹp

> **Chỉ nhóm trưởng có quyền bấm Merge** — GitHub Ruleset `chi-co-nhom-truong-duoc-merge` chặn mọi thành viên khác cập nhật `main`, kể cả khi PR đã có approve.

1. PR sẵn sàng (đã review xong hoặc cần merge) → **nhắn nhóm trưởng kèm link PR**.
2. Nhóm trưởng mở PR, bấm **Files changed** review lần cuối → bấm **Merge pull request** → **Confirm merge**.
3. Bấm **Delete branch** (nút hiện ra ngay sau khi merge) — nhánh đã gộp xong thì xóa cho gọn.
4. **Nhắn nhóm: "main đã có code mới, mọi người pull nhé"** — ai đang làm việc thì chạy `git pull --rebase origin main` trên nhánh của mình.
5. Người làm task cập nhật trạng thái trong `Task_Tracker.xlsx`.

---

## PHẦN 4 — Sơ đồ tóm tắt toàn bộ vòng lặp

```
Mở dự án ──► đọc PROJECT_CONTEXT ──► git pull main ──► tạo/chuyển nhánh ──► code + commit nhỏ
                                                                                  │
cả nhóm pull main ◄── nhóm trưởng merge ◄── review/approve ◄── tạo PR ◄── cập nhật PROJECT_CONTEXT + push
```

---

## PHẦN 5 — Xử lý tình huống thường gặp

### ❗ Lỡ code trên `main` rồi (chưa commit)

Bình tĩnh, không mất gì cả. Chỉ cần tạo nhánh mới — mọi thay đổi đi theo bạn:

```bash
git switch -c feature/<tên-task>
```

Rồi commit như bình thường trên nhánh mới.

### ❗ Lỡ commit trên `main` rồi (nhưng chưa push)

```bash
git branch feature/<tên-task>        # tạo nhánh giữ lại commit
git switch main
git reset --hard origin/main         # đưa main về đúng trạng thái trên GitHub
git switch feature/<tên-task>        # tiếp tục làm trên nhánh
```

### ❗ Gặp conflict khi `git pull --rebase origin main`

1. Git sẽ liệt kê file bị xung đột. Mở từng file, tìm đoạn:
   ```
   <<<<<<< HEAD
   (code của main)
   =======
   (code của bạn)
   >>>>>>>
   ```
2. Sửa lại thành phiên bản đúng (giữ cái nào/gộp cả hai — tùy nội dung), xóa các dòng `<<<<<<<`, `=======`, `>>>>>>>`.
3. Chạy tiếp:
   ```bash
   git add <file-đã-sửa>
   git rebase --continue
   ```
4. Rối quá muốn làm lại từ đầu: `git rebase --abort` — mọi thứ quay về như trước khi pull. Nhờ Claude hoặc thành viên khác hỗ trợ.

> 💡 Conflict với file notebook (`.ipynb`) rất khó sửa tay. Cách phòng tốt nhất: **phân công mỗi người một notebook riêng**, hạn chế 2 người cùng sửa 1 notebook.

### ❗ Push bị từ chối với lỗi `GH013: Changes must be made through a pull request`

Bạn đang push thẳng lên `main` — GitHub chặn đúng quy định. Quay lại Phần 3: push lên nhánh riêng rồi tạo PR.

### ❗ Không nhớ mình đang ở nhánh nào / đang dở việc gì

```bash
git branch --show-current    # đang ở nhánh nào
git status                   # file nào đang sửa dở
git log --oneline -5         # 5 commit gần nhất
```

---

## Các lớp bảo vệ tự động

| Lớp | Phạm vi | Tác dụng |
|---|---|---|
| Hook Claude Code (`.claude/hooks/`) | Khi làm việc qua Claude Code | Đầu phiên: nhắc pull code mới. Khi commit/push trên main: chặn + hướng dẫn tạo nhánh |
| GitHub Ruleset (`protect-main`) | Mọi thao tác push từ mọi công cụ | Chặn cứng push thẳng/force-push/xóa nhánh main; bắt buộc đi qua PR |
| GitHub Ruleset (`chi-co-nhom-truong-duoc-merge`) | Mọi thao tác cập nhật `main` | Chỉ nhóm trưởng (Repository admin) merge được PR vào main |
| `CLAUDE.md` gốc repo | Mọi phiên Claude Code | Claude chủ động tuân theo quy trình này khi được nhờ commit/push |

**Thành viên mới chỉ cần làm 1 việc:** clone repo về, mở Claude Code trong folder — mọi thứ ở trên tự có, không phải cài đặt gì thêm.
