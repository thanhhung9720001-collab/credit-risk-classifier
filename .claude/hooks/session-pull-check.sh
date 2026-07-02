#!/usr/bin/env bash
# SessionStart: nhac pull code moi nhat truoc khi bat dau lam viec.
# Fetch tu origin va bao cho Claude biet nhanh hien tai co bi cham hon remote khong.

cd "$CLAUDE_PROJECT_DIR" 2>/dev/null || exit 0
branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || exit 0

# Fetch im lang; neu mat mang thi bo qua, khong chan phien lam viec
git fetch origin --quiet 2>/dev/null

behind=$(git rev-list --count "HEAD..origin/$branch" 2>/dev/null)
[ -n "$behind" ] || behind=0

msg="QUY DINH NHOM (dau phien lam viec): nhanh hien tai la '$branch'."
if [ "$behind" -gt 0 ] 2>/dev/null; then
  msg="$msg Nhanh nay dang CHAM HON origin/$branch $behind commit - hay nhac nguoi dung chay git pull de lay code moi nhat TRUOC KHI lam viec."
else
  msg="$msg Truoc khi bat dau sua code, nen chay git pull de chac chan da co code moi nhat."
fi
if [ "$branch" = "main" ] || [ "$branch" = "master" ]; then
  msg="$msg LUU Y: dang o nhanh main - truoc khi sua code phai chuyen sang nhanh lam viec (git switch <ten-nhanh>) hoac tao nhanh moi (git switch -c feature/<ten-tinh-nang>)."
fi

printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s"}}\n' "$msg"
exit 0
