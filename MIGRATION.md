# github-deploy-latest 独立建仓迁移说明

这个目录已经按“独立仓库根目录”整理完成。真正迁出时，建议按下面步骤操作。

## 目标

- 把 `github-deploy-latest/` 变成一个单独的 GitHub 仓库
- 服务器以后直接 `git clone` 这个新仓库
- 不再依赖主仓库子目录或 sparse-checkout

## 迁移步骤

### 1. 创建新仓库

在 GitHub 上新建一个空仓库，例如：

```text
github-deploy-latest
```

### 2. 拷贝目录内容到新仓库根目录

需要迁出的文件：

- `.env.example`
- `.gitignore`
- `docker-compose.yml`
- `deploy.sh`
- `bootstrap-from-github.sh`
- `openclaw.json`
- `README.md`
- `DEPLOY-GUIDE.md`
- `MIGRATION.md`

### 3. 初始化并推送新仓库

```bash
mkdir github-deploy-latest-repo
cd github-deploy-latest-repo

# 把上述文件复制到这个目录后执行
git init
git add .
git commit -m "Initialize latest deploy repository"
git branch -M main
git remote add origin <新的 GitHub 仓库地址>
git push -u origin main
```

### 4. 更新 bootstrap 脚本默认值（可选）

迁出后，如果你愿意，可以把 `bootstrap-from-github.sh` 里的 `REPO_URL` 默认值改成新仓库地址。

### 5. 验证独立仓库可直接部署

```bash
git clone <新的 GitHub 仓库地址> /root/openclaw-deploy-latest
cd /root/openclaw-deploy-latest
cp .env.example .env
./deploy.sh
```

## 说明

- 迁出后不需要修改 `deploy.sh` 的部署行为
- 当前目录中的部署逻辑已经是独立的，迁移重点只是仓库边界和文档入口
