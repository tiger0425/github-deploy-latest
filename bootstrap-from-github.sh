#!/bin/bash
# 克隆 github-deploy-latest 独立仓库并准备部署目录

set -euo pipefail

REPO_URL="${REPO_URL:-https://github.com/tiger0425/github-deploy-latest.git}"
TARGET_DIR="${TARGET_DIR:-/root/openclaw-deploy-latest}"

if [ -z "$REPO_URL" ]; then
    echo "❌ 请先设置 REPO_URL"
    echo "示例："
    echo "  export REPO_URL=https://github.com/<your-org>/<your-repo>.git"
    exit 1
fi

if [ -d "$TARGET_DIR/.git" ]; then
    echo "📦 仓库已存在，执行更新..."
    git -C "$TARGET_DIR" pull --ff-only
else
    echo "📦 首次克隆仓库..."
    git clone --depth 1 "$REPO_URL" "$TARGET_DIR"
fi

echo "✅ 已准备好目录: ${TARGET_DIR}"
echo "进入目录后执行:"
echo "  cd ${TARGET_DIR}"
echo "  cp .env.example .env"
echo "  ./deploy.sh"
