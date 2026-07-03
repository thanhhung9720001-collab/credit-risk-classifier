# Thư mục `context/` — nhật ký ngữ cảnh cá nhân

Mỗi thành viên có **một file context riêng**: `context/<ten>.md` (tên viết thường, không dấu — trùng với tên khai báo trong `.claude/whoami`).

## Vì sao tách file riêng?

`PROJECT_CONTEXT.md` (ở gốc repo) là **bức tranh tổng** của cả dự án, do **nhóm trưởng làm chủ**. Nếu mọi người cùng sửa file đó thì rất dễ **xung đột (conflict)** vì cùng đụng vào một vài dòng.

Tách mỗi người một file trong `context/` → **mỗi file chỉ do đúng một người sửa** → hai người sửa hai file khác nhau, git không bao giờ đụng nhau → **hết conflict**.

## Quy tắc

1. **Chỉ sửa file context của chính mình.** Không đụng file của người khác.
2. File của bạn = nơi ghi: đang làm task gì, ở nhánh nào, làm tới đâu, còn gì dở, ghi chú riêng.
3. Cập nhật thường xuyên (cuối mỗi buổi làm việc) và commit **ngay trong nhánh task của bạn** — đi cùng PR, không tạo PR riêng.
4. Tạo file mới: copy `_TEMPLATE.md` thành `context/<ten-cua-ban>.md`.

## Khai báo tên (đầu mỗi phiên)

Mỗi máy khai báo **một lần**: tạo file `.claude/whoami` chứa tên viết thường không dấu, ví dụ:

```bash
echo hung > .claude/whoami
```

(Hoặc nói với Claude: *"Tôi là <tên>"* — Claude sẽ tạo giúp.) File này **không commit** (đã có trong `.gitignore`). Từ đó về sau, mỗi phiên hook sẽ tự chào bạn và nhắc đúng file context của bạn.
