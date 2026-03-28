# OpenClaw 最新 release 云服务器部署包

这个仓库用于从阿里云 ACR 拉取镜像并在服务器上部署。

## 默认镜像

默认使用：

```bash
registry.cn-shenzhen.aliyuncs.com/yihuzh/openclaw:latest
```

如果你想部署具体版本，也可以在运行前设置：

```bash
export OPENCLAW_IMAGE_NAME=registry.cn-shenzhen.aliyuncs.com/yihuzh/openclaw:v2026.3.23
```

生产环境更推荐显式指定具体版本 tag，这样部署结果可复现。`latest` 更适合快速验证。

## 快速部署

### 方式一：直接克隆独立仓库（推荐）

```bash
git clone <你的 github-deploy-latest 仓库地址> /root/openclaw-deploy-latest
cd /root/openclaw-deploy-latest
cp .env.example .env
vim .env
chmod +x deploy.sh
./deploy.sh
```

### 方式二：使用辅助脚本

```bash
chmod +x bootstrap-from-github.sh
export REPO_URL=<你的 github-deploy-latest 仓库地址>
./bootstrap-from-github.sh
```

## 需要填写的配置

- `OPENCLAW_GATEWAY_TOKEN`
- `LARK_APP_ID`
- `LARK_APP_SECRET`

## 部署脚本做什么

- 检查 Docker / Docker Compose
- 读取 `.env`
- 自动拉取阿里云 ACR 镜像
- 启动 `docker-compose.yml`

## latest 的行为说明

- 当使用 `latest` 时，`deploy.sh` 每次部署都会先执行一次 `docker pull`
- 当使用具体版本 tag 时，如果本地不存在该镜像才会拉取
- 如果你希望确定性发布，请优先传入具体版本 tag

## 仓库定位

- 这个仓库面向“最新版本快速验证”
- 默认使用阿里云 ACR 的 `latest` 镜像
- 如果需要生产级可复现部署，建议改用具体版本 tag

> 当前这套文件仍托管在主仓库里维护，但文档已经按“独立仓库根目录”写法整理，迁出后可直接使用。
