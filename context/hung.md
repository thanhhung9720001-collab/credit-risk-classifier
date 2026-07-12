# Context cá nhân — Hưng (nhóm trưởng)

> Chỉ mình Hưng sửa file này. Cập nhật cuối mỗi buổi làm việc rồi commit ngay trong nhánh task.

## Đang làm

- **Task:** Cập nhật `PROJECT_CONTEXT.md` và `context/hung.md` sau khi hoàn thành SQL Views (T05)
- **Nhánh:** `docs/cap-nhat-project-context-views`
- **Trạng thái:** Đang thực hiện (đã chỉnh sửa file cục bộ, chuẩn bị push PR)

## Làm tới đâu (cập nhật mới nhất ở trên)

- **2026-07-12:** Tạo nhánh `docs/cap-nhat-project-context-views` và cập nhật `PROJECT_CONTEXT.md` để ghi nhận việc hoàn thành và merge thành công task T05 (tạo views - PR #19) vào `main`.
- **2026-07-12:** Merge thành công PR #19 gộp task T05 (views) vào `main`, sau đó switch về `main` cục bộ và `git pull` để đồng bộ code mới nhất.
- **2026-07-12:** Thực hiện và hoàn thành viết mã cho [03_views.sql](file:///d:/FPT%20Polytechnic/2026/HK%20Summer%202026/Block2/Du-an-01/credit-risk-classifier/sql/03_views.sql) bao gồm 7 views chi tiết làm sạch và tính toán đặc trưng tài chính từ 8 bảng thô. Đã khắc phục lỗi cú pháp UNION và bổ sung comment giải thích nghiệp vụ (như khái niệm CIC, cách tính tỷ lệ nợ/sử dụng thẻ, số ngày trễ hạn).
- **2026-07-12:** Đã merge nhánh `docs/hung-cap-nhat-project-context` để cập nhật trạng thái chung của dự án sau khi hoàn thành tạo bảng (T02) và import (T03).
- **2026-07-03:** Dựng `AGENTS.md` làm nguồn sự thật duy nhất cho quy định nhóm (mirror nội dung CLAUDE.md cũ); `CLAUDE.md` giờ chỉ còn `@AGENTS.md` (Claude Code tự nạp). Mục đích: dùng xen kẽ Claude Code và Antigravity mà không lệch quy định. Lưu ý đã ghi trong AGENTS.md: hook `.claude/` chỉ Claude Code chạy, Antigravity không có — dựa vào GitHub Ruleset + kỷ luật.
- **2026-07-03:** Đã merge T01 (PR #12) → notebook 01 có trên `main`. Cập nhật `PROJECT_CONTEXT.md` mục 3 (notebook 01 xong, 02→07 còn rỗng) & mục 4 (hướng tiếp theo). **Rút kinh nghiệm:** tên nhánh phải có mã task ở đầu (vd `feature/t01-...`) — lần T01 đã lỡ đặt thiếu mã.
- **2026-07-03:** Hoàn thành notebook 01 (32 cell, đúng quy ước format nhóm): (1) chuẩn bị môi trường; (2) tổng quan 8 bảng — dòng/cột/RAM/tỷ lệ thiếu; (3) bảng trung tâm `application_train` (307.511×122): kiểu dữ liệu, `TARGET` mất cân bằng ~8%, missing (67 cột thiếu), thống kê mô tả; (4) bảng phụ & quan hệ khóa `SK_ID_CURR/BUREAU/PREV`; (5) từ điển dữ liệu; (6) tổng kết dẫn sang notebook 02. Đã `nbconvert --execute` nhúng output thật (3 biểu đồ), không lỗi. Đã cài `nbconvert` để thực thi notebook (chưa thêm vào `requirements.txt` — thuộc task README/requirements riêng).
- **2026-07-03:** Đã merge (PR #5, #6, #7): nội quy "chỉ nhóm trưởng đổi cấu trúc/quy trình", context cá nhân theo từng thành viên, khai báo tên qua `.claude/whoami`, hook `edit-branch-guard` chặn sửa file trên main. Đã cập nhật `PROJECT_CONTEXT.md`.

## Còn dở / việc tiếp theo của tôi

- [ ] Push nhánh `docs/cap-nhat-project-context-views` lên GitHub, tạo Pull Request và tự merge vào `main` (sau khi review kỹ).
- [ ] Phối hợp với nhóm để chốt và phân công các task tiếp theo (Notebook 02, SQL Views/Aggregations/Indexes, README & Requirements).

## Ghi chú riêng

- Nhóm trưởng: Hưng — người duy nhất được merge PR vào `main` và đổi cấu trúc/quy trình.
