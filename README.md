# Node.js Android CI

自动化每日检查并编译 Node.js Android 版本。

## 工作流说明

### build.yml

单一工作流，包含以下任务：

1. **check-version** - 检查Node.js版本
   - 每天UTC 0:00自动执行（对应北京时间早上8点）
   - 可手动触发，手动指定版本号

2. **build-arm64** - 编译 arm64 架构
   - Android 7.0+ 64位设备
   - 仅编译指定版本，不发布Release

3. **release** - 发布版本
   - 仅当发现新版本时执行
   - 创建GitHub Release并上传编译产物

## 手动触发

在 GitHub Actions 页面点击 "Node.js Android 自动化编译" 工作流，
点击 "Run workflow"，可选择指定版本号或留空自动检查最新版本。

## 本地编译

```bash
# 克隆仓库
git clone https://github.com/YOUR_USERNAME/node-android-ci.git
cd node-android-ci

# 触发工作流
gh workflow run build.yml --field node_version=24.0.0
```

## 编译产物

编译完成后，二进制文件位于：
- `output/arm64/node-{版本号}-android-arm64`

## 技术规格

- **目标架构**: arm64 (aarch64)
- **最低Android版本**: Android 7.0 (API 24)
- **NDK版本**: r27d
- **编译选项**: --openssl-no-asm

## 注意事项

- 此项目与 Node.js 官方项目无关联
- 编译产物仅包含 arm64 架构
