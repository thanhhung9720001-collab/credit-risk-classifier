# Context cá nhân — Hưng (nhóm trưởng)

> Chỉ mình Hưng sửa file này. Cập nhật cuối mỗi buổi làm việc rồi commit ngay trong nhánh task.

## Đang làm

- **Task:** Thêm `AGENTS.md` để dùng song song Claude Code + Antigravity
- **Nhánh:** `docs/them-agents-md`
- **Trạng thái:** đã tạo AGENTS.md + rút gọn CLAUDE.md thành `@AGENTS.md`, chờ tạo PR & merge

## Làm tới đâu (cập nhật mới nhất ở trên)

- **2026-07-03:** Dựng `AGENTS.md` làm nguồn sự thật duy nhất cho quy định nhóm (mirror nội dung CLAUDE.md cũ); `CLAUDE.md` giờ chỉ còn `@AGENTS.md` (Claude Code tự nạp). Mục đích: dùng xen kẽ Claude Code và Antigravity mà không lệch quy định. Lưu ý đã ghi trong AGENTS.md: hook `.claude/` chỉ Claude Code chạy, Antigravity không có — dựa vào GitHub Ruleset + kỷ luật.
- **2026-07-03:** Đã merge T01 (PR #12) → notebook 01 có trên `main`. Cập nhật `PROJECT_CONTEXT.md` mục 3 (notebook 01 xong, 02→07 còn rỗng) & mục 4 (hướng tiếp theo). **Rút kinh nghiệm:** tên nhánh phải có mã task ở đầu (vd `feature/t01-...`) — lần T01 đã lỡ đặt thiếu mã.
- **2026-07-03:** Hoàn thành notebook 01 (32 cell, đúng quy ước format nhóm): (1) chuẩn bị môi trường; (2) tổng quan 8 bảng — dòng/cột/RAM/tỷ lệ thiếu; (3) bảng trung tâm `application_train` (307.511×122): kiểu dữ liệu, `TARGET` mất cân bằng ~8%, missing (67 cột thiếu), thống kê mô tả; (4) bảng phụ & quan hệ khóa `SK_ID_CURR/BUREAU/PREV`; (5) từ điển dữ liệu; (6) tổng kết dẫn sang notebook 02. Đã `nbconvert --execute` nhúng output thật (3 biểu đồ), không lỗi. Đã cài `nbconvert` để thực thi notebook (chưa thêm vào `requirements.txt` — thuộc task README/requirements riêng).
- **2026-07-03:** Đã merge (PR #5, #6, #7): nội quy "chỉ nhóm trưởng đổi cấu trúc/quy trình", context cá nhân theo từng thành viên, khai báo tên qua `.claude/whoami`, hook `edit-branch-guard` chặn sửa file trên main. Đã cập nhật `PROJECT_CONTEXT.md`.

## Còn dở / việc tiếp theo của tôi

- [ ] Push nhánh `feature/notebook-01-data-understanding` + tạo PR, review rồi merge
- [ ] Sau khi merge: cập nhật mục 3 & 4 trong `PROJECT_CONTEXT.md` (đánh dấu notebook 01 đã có nội dung)
- [ ] Nhắc mỗi thành viên: pull main, tạo `.claude/whoami` + `context/<ten>.md`, khởi động lại Claude Code để nạp hook

## Ghi chú riêng

- Nhóm trưởng: Hưng — người duy nhất được merge PR vào `main` và đổi cấu trúc/quy trình.
