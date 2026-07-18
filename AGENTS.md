# credit-risk-classifier — Quy định làm việc nhóm

> **File này là NGUỒN SỰ THẬT DUY NHẤT cho quy định nhóm.** Cả Claude Code (qua `CLAUDE.md` chỉ `@AGENTS.md`) lẫn Antigravity (đọc thẳng `AGENTS.md`) đều dùng file này — sửa quy định thì sửa ở ĐÂY.
>
> Quy trình đầy đủ (kèm hướng dẫn chi tiết từng bước và xử lý tình huống): xem `docs/QUY-TRINH-LAM-VIEC.md`.

## Quy trình Git (BẮT BUỘC với mọi thành viên)

1. **Trước khi bắt đầu làm việc**: luôn lấy code mới nhất về trước.
   ```
   git fetch origin
   git pull
   ```
2. **Kiểm tra nhánh hiện tại** trước khi sửa code: `git branch --show-current`.
   - Nếu đang ở `main`: **không được code trực tiếp**. Chuyển sang nhánh làm việc (`git switch <tên-nhánh>`), hoặc tạo nhánh mới từ main mới nhất:
     ```
     git pull origin main
     git switch -c feature/<tên-tính-năng>
     ```
3. **Không bao giờ commit / push / merge trực tiếp trên nhánh `main`.** (Có hook tự động chặn — xem `.claude/hooks/git-branch-guard.sh`.)
4. **Đặt tên nhánh** theo quy ước: `feature/<tên>` (tính năng mới), `fix/<tên>` (sửa lỗi), `docs/<tên>` (tài liệu). Nếu task có mã (T01, T02...) thì đưa mã vào đầu mô tả: `feature/t01-<tên>`.
5. **Trước khi push**: cập nhật nhánh với main mới nhất để tránh xung đột:
   ```
   git pull --rebase origin main
   ```
6. **Push nhánh và tạo Pull Request** trên GitHub để cả nhóm review — không merge thẳng vào main.

## Quyền thay đổi cấu trúc & quy định (chỉ nhóm trưởng)

- **Không tự ý thay đổi cấu trúc thư mục, quy trình hay quy định của nhóm.** Chỉ **nhóm trưởng (Hưng)** mới được quyết định. Chi tiết: xem `docs/QUY-TRINH-LAM-VIEC.md` — Phần 0.
- Phạm vi bị khóa: cấu trúc thư mục gốc (`notebooks/`, `sql/`, `app/`, `models/`, `data/`, `reports/`, `docs/`...), các bước quy trình làm việc, `AGENTS.md` / `CLAUDE.md`, hook trong `.claude/`, GitHub Ruleset, quy ước định dạng notebook.
- Thành viên **được tự do** viết nội dung code/notebook/SQL/app bên trong cấu trúc đã có và thêm file mới đúng chỗ theo quy ước.

## Khai báo tên & context cá nhân

- **Đầu mỗi phiên phải biết ai đang làm việc.** Tên thành viên lưu ở `.claude/whoami` (viết thường không dấu, mỗi máy khai báo 1 lần, file này KHÔNG commit — đã gitignore).
- Nếu `.claude/whoami` **chưa có / rỗng**: hỏi người dùng họ tên, tạo `.claude/whoami` chứa tên viết thường không dấu, rồi tạo `context/<ten>.md` từ mẫu `context/_TEMPLATE.md` **trước khi** bắt đầu công việc.
- `PROJECT_CONTEXT.md` = bức tranh tổng của dự án, **do nhóm trưởng làm chủ** — thành viên **đọc**, không sửa (trừ nhóm trưởng).
- Tiến độ/ghi chú cá nhân ghi vào `context/<ten>.md` của chính người đó — **không đụng file context của người khác** (tránh conflict). Cập nhật file này khi kết thúc buổi làm việc, commit ngay trong nhánh task.

## Hướng dẫn cho AI agent (Claude Code, Antigravity...)

- Đầu phiên làm việc: đọc `PROJECT_CONTEXT.md` (mục 3 và 4) để nắm trạng thái dự án; và đọc `context/<ten>.md` của thành viên đang làm để biết họ đang dở việc gì.
- Khi cần hiểu hướng dẫn, bài giảng và tài liệu tham chiếu của giảng viên: đọc `docs/huong-dan-giang-vien/README.md`. Đây là nguồn tham khảo để hiểu định hướng của thầy, không thay thế `AGENTS.md`, `PROJECT_CONTEXT.md` hay đề bài gốc.
- **Khi động vào file trong `notebooks/`: đọc thêm `PROJECT_CONTEXT.md` mục 6 (Quy ước định dạng notebook) TRƯỚC KHI sửa** — mục 3/4 không chứa quy ước này.
  - ⚠️ **Không có quy định "notebook phải đủ 6 mục lớn".** Số mục lớn **không cố định, tuỳ nội dung** (NB01 có 6 mục, NB02–NB06 có 7 — đều đúng). Quy định thật là **mục Tổng kết phải đứng CUỐI**, mang số thứ tự kế tiếp của notebook đó. **Đừng nhồi/gộp mục cho khớp một con số nào cả.**
  - Markdown trước code chỉ viết ngắn gọn để dẫn vào bước chạy, ưu tiên dạng "Đoạn code bên dưới..."; không viết dài kiểu "cell này làm gì/vì sao/output mong đợi". Markdown sau output dùng để **nhận xét/kết luận từ kết quả**. Nếu cần giải thích kỹ thuật, viết comment ngắn ngay trong cell code.
- **Trước khi sửa bất kỳ file nào trong repo (Edit/Write): kiểm tra lại nhánh bằng `git branch --show-current` — đừng dựa vào trí nhớ.** Người dùng có thể đã tự đổi về `main` mà AI không biết. Nếu đang ở `main`, chuyển sang nhánh làm việc trước khi sửa (Claude Code có hook `edit-branch-guard.sh` chặn tự động; Antigravity KHÔNG có hook này nên phải tự kiểm tra kỹ hơn).
- Khi người dùng yêu cầu commit/push: luôn kiểm tra nhánh hiện tại trước. Nếu đang ở `main`, hướng dẫn pull code mới nhất rồi tạo/chuyển nhánh theo quy ước ở trên, sau đó mới commit/push.
- Đầu phiên làm việc: nhắc người dùng pull code mới nhất nếu nhánh đang chậm hơn remote.
- Khi hoàn thành một phần việc / cuối buổi: cập nhật `context/<ten>.md` của thành viên đang làm (đang làm gì, tới đâu, còn dở gì), commit ngay trong nhánh của task đó (đi cùng PR).
- Cập nhật mục **3. Trạng thái hiện tại** và **4. Việc tiếp theo** trong `PROJECT_CONTEXT.md` là việc của **nhóm trưởng** (thường làm khi merge PR) — thành viên khác không sửa file này.
- Commit message viết tiếng Việt không dấu, theo dạng `<loại>: <mô tả>` (ví dụ: `docs: them cell tieu de chuan cho notebook`).
- Khi được nhờ đổi cấu trúc thư mục / quy trình / quy định nhóm (phạm vi bị khóa ở trên): nhắc đây là việc chỉ nhóm trưởng được quyết. Nếu người dùng không phải nhóm trưởng, đề nghị họ xin ý kiến nhóm trưởng trước; chỉ thực hiện khi có xác nhận của nhóm trưởng.

## Ghi chú về công cụ (Claude Code vs Antigravity)

- **Điểm chung (bất kể công cụ):** repo git, nhánh, PR và **GitHub Ruleset** (`protect-main`, chỉ nhóm trưởng merge) — Ruleset chặn ở phía server nên luôn hiệu lực dù dùng công cụ nào.
- **Chỉ Claude Code có:** các hook trong `.claude/` (chặn commit/sửa file trên `main`, chào tên + nhắc pull đầu phiên) và tự đọc `CLAUDE.md`. **Antigravity KHÔNG chạy các hook này** — trên Antigravity phải dựa vào kỷ luật cá nhân + Ruleset, và tự kiểm tra nhánh trước khi sửa/commit.
