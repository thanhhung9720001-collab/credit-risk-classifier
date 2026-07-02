#!/usr/bin/env bash
# PreToolUse guard cho ca nhom: chan git commit/push/merge truc tiep tren nhanh main,
# nhac dong bo code moi nhat truoc khi push tren nhanh feature.
# Nhan JSON tu stdin (tool_input.command), khong dung jq de khoi phai cai them.

input=$(cat)

# Chi quan tam cac lenh git thay doi lich su / day code
case "$input" in
  *"git commit"* | *"git push"* | *"git merge"*) ;;
  *) exit 0 ;;
esac

cd "$CLAUDE_PROJECT_DIR" 2>/dev/null
branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || exit 0

if [ "$branch" = "main" ] || [ "$branch" = "master" ]; then
  cat <<'EOF'
{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"QUY DINH NHOM: Dang dung o nhanh 'main' - KHONG duoc commit/push/merge truc tiep. Hay lam theo thu tu: (1) git fetch origin && git pull origin main de lay code moi nhat; (2) neu da co nhanh lam viec thi chuyen qua: git switch <ten-nhanh>; neu chua co thi tao nhanh moi tu main: git switch -c feature/<ten-tinh-nang>; (3) thuc hien lai commit/push tren nhanh do va tao Pull Request, KHONG push thang len main."}}
EOF
  exit 0
fi

# Dang o nhanh feature: van cho chay, nhung nhac dong bo voi main truoc khi push
case "$input" in
  *"git push"*)
    cat <<EOF
{"hookSpecificOutput":{"hookEventName":"PreToolUse","additionalContext":"Nhac nho truoc khi push nhanh '$branch': neu chua lam thi nen git fetch origin va cap nhat nhanh voi main moi nhat (git pull --rebase origin main) de tranh xung dot khi tao Pull Request."}}
EOF
    ;;
esac

exit 0
