# OpenClaw 最新 release 阿里云部署指南

## 方式一：直接克隆独立仓库

```bash
git clone https://github.com/tiger0425/github-deploy-latest.git /root/openclaw-deploy-latest
cd /root/openclaw-deploy-latest
cp .env.example .env
vim .env
chmod +x deploy.sh
./deploy.sh
```

说明：这里的文档按独立仓库根目录书写，不依赖主仓库的目录结构。

## 方式二：部署指定版本标签

```bash
export OPENCLAW_IMAGE_NAME=registry.cn-shenzhen.aliyuncs.com/yihuzh/openclaw:v2026.3.23
./deploy.sh
```

建议生产环境优先使用这种方式，便于回滚与审计。

## 迁移前临时用法

如果当前还没拆出独立仓库，可以先在主仓库里进入这个目录使用，但建议尽快迁出，避免文档与真实拉取地址长期不一致。

## 常用命令

```bash
docker ps
docker logs -f openclaw-latest-gateway
docker-compose restart
docker-compose down
```

## 验证点

- 容器已启动
- 飞书 WebSocket 已连接
- 飞书里 @ 机器人可正常响应

## 部署约定

- 每次执行 `./deploy.sh` 时，都会同步仓库里的 `openclaw.json` 到运行目录，避免旧配置残留。
- 如果需要修改 Control UI 的 origin 策略，请优先改仓库中的 `openclaw.json`，再重新部署。
