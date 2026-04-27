# Node.js Android CI

自动化每日检查并编译 Node.js Android 版本。

## 功能特性

- **每日自动检查**：每天 UTC 0:00 自动检查 Node.js 官方最新版本
- **交叉编译**：使用 Android NDK 为 Android 平台交叉编译 Node.js
- **自动发布**：发现新版本时自动创建 GitHub Release
- **手动触发**：支持手动指定版本号进行编译

## 支持架构

- **arm64 (aarch64)**：Android 7.0+ 64位设备

## 工作流说明

### build.yml

单一工作流，包含以下任务：

1. **check-version** - 检查Node.js版本
   - 每天 UTC 0:00 自动执行（对应北京时间早上8点）
   - 可手动触发，手动指定版本号
   - 比较本地版本与远程版本，决定是否需要编译

2. **build-arm64** - 编译 arm64 版本
   - 使用 `android-actions/setup-android` 安装 NDK
   - 动态查找并配置交叉编译工具链
   - 编译完成后上传构建产物

3. **release** - 发布版本
   - 仅当发现新版本时执行
   - 创建 GitHub Release 并上传编译产物
   - 更新本地 `.version` 文件

## 手动触发

在 GitHub Actions 页面点击 "Node.js Android 自动化编译" 工作流，
点击 "Run workflow"，可选择指定版本号或留空自动检查最新版本。

## 本地使用

```bash
# 克隆仓库
git clone https://github.com/Alien-Et/nodejs.git
cd nodejs

# 手动触发工作流
gh workflow run build.yml --field node_version=24.0.0
```

## 编译产物

编译完成后，二进制文件位于：
- `output/arm64/node-{版本号}-android-arm64`

## 使用方法

1. 下载对应架构的二进制文件
2. 赋予执行权限：`chmod +x node`
3. 运行：`./node --version`

## 技术规格

| 项目 | 值 |
|------|-----|
| 目标架构 | arm64 (aarch64) |
| 最低Android版本 | Android 7.0 (API 24) |
| NDK版本 | r27d |
| 编译选项 | --openssl-no-asm |
| Node.js 版本 | v24+ |

## 注意事项

- 此项目与 Node.js 官方项目无关联
- 编译产物仅包含 arm64 架构
- 编译产物为预发布版本 (prerelease)
