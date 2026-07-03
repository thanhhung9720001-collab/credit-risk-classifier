#!/usr/bin/env bash
# PreToolUse guard cho ca nhom: chan sua file (Edit/Write/NotebookEdit) khi dang o nhanh main.
# Ly do: neu ai do doi ve main thu cong ma Claude khong biet, Claude co the vo tinh sua file
# tren main. Hook nay kiem tra nhanh NGAY TRUOC MOI lan sua file -> khong con phu thuoc tri nho.
# Chi chan file NAM TRONG repo va KHONG bi gitignore; file ngoai repo (scratchpad) hoac
# file gitignore (.claude/whoami, .omc/, data/...) van cho sua binh thuong.
# Nhan JSON tu stdin (tool_input.file_path hoac notebook_path), khong dung jq.

input=$(cat)

proj="$CLAUDE_PROJECT_DIR"
[ -n "$proj" ] || exit 0

branch=$(git -C "$proj" rev-parse --abbrev-ref HEAD 2>/dev/null) || exit 0
[ "$branch" = "main" ] || [ "$branch" = "master" ] || exit 0

# Lay duong dan file tu tool_input (Edit/Write dung file_path, NotebookEdit dung notebook_path)
fp=$(printf '%s' "$input" | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
[ -n "$fp" ] || fp=$(printf '%s' "$input" | sed -n 's/.*"notebook_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
[ -n "$fp" ] || exit 0

# JSON escape: \\ -> \ ; sau do chuan hoa ve chu thuong + dung dau /
fp=$(printf '%s' "$fp" | sed 's/\\\\/\\/g')
norm() { printf '%s' "$1" | tr 'A-Z' 'a-z' | tr '\\' '/'; }
fp_n=$(norm "$fp")
proj_n=$(norm "$proj")

# Ngoai repo (vd scratchpad) -> cho sua
case "$fp_n" in
  "$proj_n"/*) : ;;
  *) exit 0 ;;
esac

rel="${fp_n#"$proj_n"/}"

# File bi gitignore (.claude/whoami, .omc/, data/, models/...) -> cho sua
if git -C "$proj" check-ignore -q -- "$rel" 2>/dev/null; then
  exit 0
fi

# Con lai: file commit duoc, dang o main -> CHAN
cat <<'EOF'
{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"QUY DINH NHOM: Dang o nhanh 'main' - KHONG duoc sua file trong repo tren main (co the ai do vua doi nhanh thu cong). Hay: (1) git branch --show-current de xac nhan; (2) git switch <ten-nhanh> (hoac git switch -c feature/<ten> tao nhanh moi tu main da pull); (3) sua file lai tren nhanh do. Luu y: file gitignore (.claude/whoami) hay file ngoai repo van sua duoc; lenh nay chi chan file commit duoc."}}
EOF
exit 0
