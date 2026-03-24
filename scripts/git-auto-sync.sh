#!/bin/bash
# Git Auto-Sync Script
# 監控 workspace 檔案變動，自動 commit + push

REPO_DIR="/home/node/.openclaw/workspace"
BRANCH="main"

echo "[git-auto-sync] 開始監控 $REPO_DIR"
echo "[git-auto-sync] 按 Ctrl+C 停止"

# 初始化計數
count=0

# 使用 inotifywait 監控檔案變動
while true; do
  # 等待檔案變動
  inotifywait -r -e modify,create,delete,move "$REPO_DIR" \
    --exclude '\.git/' \
    --exclude '\.openclaw/' \
    --quiet 2>/dev/null
    
  count=$((count + 1))
  echo "[git-auto-sync] 偵測到變動 (#$count) - 等待稳定..."
  
  # 等待檔案寫入完成（避免同時觸發）
  sleep 3
  
  # 檢查是否有變更
  cd "$REPO_DIR" || exit 1
  
  if ! git diff --quiet || ! git diff --cached --quiet || [ -n "$(git status --porcelain)" ]; then
    echo "[git-auto-sync] 發現變更，執行同步..."
    
    # Add all changes
    git add -A
    
    # 取得變更檔案列表
    changed_files=$(git diff --cached --name-only | head -10)
    
    # Commit with timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    git commit -m "Auto-sync: $timestamp" -m "Updated files:
$changed_files" 2>/dev/null
    
    # Push
    if git push origin "$BRANCH" 2>&1; then
      echo "[git-auto-sync] ✅ 同步成功！"
    else
      echo "[git-auto-sync] ⚠️ Push 失敗（可能沒有變更）"
    fi
  fi
  
done
