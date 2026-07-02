# credit-risk-classifier — Quy định làm việc nhóm

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
4. **Đặt tên nhánh** theo quy ước: `feature/<tên>` (tính năng mới), `fix/<tên>` (sửa lỗi), `docs/<tên>` (tài liệu).
5. **Trước khi push**: cập nhật nhánh với main mới nhất để tránh xung đột:
   ```
   git pull --rebase origin main
   ```
6. **Push nhánh và tạo Pull Request** trên GitHub để cả nhóm review — không merge thẳng vào main.

## Hướng dẫn cho Claude

- Khi người dùng yêu cầu commit/push: luôn kiểm tra nhánh hiện tại trước. Nếu đang ở `main`, hướng dẫn pull code mới nhất rồi tạo/chuyển nhánh theo quy ước ở trên, sau đó mới commit/push.
- Đầu phiên làm việc: nhắc người dùng pull code mới nhất nếu nhánh đang chậm hơn remote.
- Commit message viết tiếng Việt không dấu, theo dạng `<loại>: <mô tả>` (ví dụ: `docs: them cell tieu de chuan cho notebook`).
