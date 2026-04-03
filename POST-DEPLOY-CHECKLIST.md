# OpenClaw 最新 release 上线验收清单

部署完成后，请按下面顺序检查：

## 1. 容器状态

```bash
docker ps --format '{{.Names}}|{{.Image}}|{{.Status}}'
```

应看到：

- `openclaw-latest-gateway`
- `openclaw-latest-headless-shell`

## 2. 配置同步

确认运行目录中的配置已经同步：

```bash
sed -n '1,120p' /data/openclaw-deploy-latest/openclaw_data/openclaw.json
```

应确认：

- `channels.feishu.connectionMode = "websocket"`
- `gateway.controlUi.dangerouslyAllowHostHeaderOriginFallback = true`

## 3. 飞书连通性

查看最近日志：

```bash
docker logs --since 3m openclaw-latest-gateway
```

应看到：

- `WebSocket client started`
- `ws client ready`
- 收到消息后有 `received message`
- 有 `dispatching to agent`
- 有 `dispatch complete`

## 4. 消息响应测试

分别测试：

- 私聊机器人发一条消息
- 群聊里 @ 机器人发一条消息

## 5. 常见失败点

- `.env` 是假值或过期值
- `openclaw.json` 未同步到运行目录
- 远端误用旧版 `docker-compose`
- `Control UI` 非 loopback 时缺少 `controlUi` 配置
- 飞书后台事件订阅未开或权限未授予
