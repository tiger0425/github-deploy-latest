#!/bin/bash
# OpenClaw 最新 release 阿里云部署脚本

set -euo pipefail

DEFAULT_IMAGE="registry.cn-shenzhen.aliyuncs.com/yihuzh/openclaw:latest"
IMAGE_NAME="${OPENCLAW_IMAGE_NAME:-$DEFAULT_IMAGE}"
IMAGE_TAG="${IMAGE_NAME##*:}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "🦞 OpenClaw 最新 release 阿里云部署"
echo "镜像: ${IMAGE_NAME}"
echo ""

if [ "$EUID" -eq 0 ]; then
   echo -e "${RED}❌ 请不要以 root 用户运行此脚本${NC}"
   exit 1
fi

if ! command -v docker >/dev/null 2>&1; then
    echo -e "${RED}❌ Docker 未安装${NC}"
    exit 1
fi

if ! command -v docker-compose >/dev/null 2>&1 && ! docker compose version >/dev/null 2>&1; then
    echo -e "${RED}❌ Docker Compose 未安装${NC}"
    exit 1
fi

if [ ! -f .env ]; then
    echo -e "${YELLOW}⚠️  .env 文件不存在，请先执行 cp .env.example .env${NC}"
    exit 1
fi

if ! grep -q "LARK_APP_ID=" .env || grep -q "LARK_APP_ID=cli_xxxxx" .env; then
    echo -e "${RED}❌ 请配置 LARK_APP_ID${NC}"
    exit 1
fi

if ! grep -q "LARK_APP_SECRET=" .env || grep -q "LARK_APP_SECRET=xxxxx" .env; then
    echo -e "${RED}❌ 请配置 LARK_APP_SECRET${NC}"
    exit 1
fi

mkdir -p openclaw_data
mkdir -p openclaw_data/workspace
chmod 755 openclaw_data
chmod 755 openclaw_data/workspace

echo "🧩 同步部署配置..."
cp -f openclaw.json openclaw_data/openclaw.json

echo "🔍 检查镜像..."
if [ "$IMAGE_TAG" = "latest" ]; then
    echo -e "${YELLOW}⚠️  当前使用 latest 标签，部署前将强制拉取远端最新镜像${NC}"
    docker pull "$IMAGE_NAME"
elif ! docker image inspect "$IMAGE_NAME" >/dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  本地不存在，开始拉取 ${IMAGE_NAME}${NC}"
    docker pull "$IMAGE_NAME"
fi

if docker compose version >/dev/null 2>&1; then
    COMPOSE_CMD=(docker compose)
elif command -v docker-compose >/dev/null 2>&1; then
    COMPOSE_CMD=(docker-compose)
else
    echo -e "${RED}❌ Docker Compose 未安装${NC}"
    exit 1
fi

export OPENCLAW_IMAGE_NAME="$IMAGE_NAME"

"${COMPOSE_CMD[@]}" down 2>/dev/null || true
"${COMPOSE_CMD[@]}" up -d

echo ""
echo -e "${GREEN}✅ 部署完成${NC}"
echo "查看状态: ${COMPOSE_CMD[*]} ps"
echo "查看日志: docker logs -f openclaw-latest-gateway"
