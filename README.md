# Node.js Android CI

自动化每日检查并编译 Node.js Android 版本。

## 功能特性

- **每日自动检查**：每天 UTC 0:00 自动检查 Node.js 官方最新版本
- **交叉编译**：使用 Android NDK 为 Android 平台交叉编译 Node.js
- **自动发布**：发现新版本时自动创建 GitHub Release
- **手动触发**：支持手动指定版本号进行编译
- **多种编译方式**：提供两种编译方式供选择

## 支持架构

- **arm64 (aarch64)**：Android 7.0+ 64位设备

## 工作流说明

### 1. build.yml - 标准编译方式

使用 Android NDK 直接编译，应用 simdutf 函数名称修复补丁。

**任务：**
1. **check-version** - 检查Node.js版本
2. **build-arm64** - 编译 arm64 版本
3. **release** - 发布版本

### 2. build-termux.yml - Termux 官方方式

使用 Termux 官方补丁和编译方式，更加稳定可靠。

**任务：**
1. **check-version** - 检查Node.js版本
2. **build-arm64** - 克隆 Termux 包仓库并应用补丁
3. **release** - 发布版本

**特点：**
- 自动克隆 Termux 包仓库
- 应用所有 Termux Node.js 补丁
- 使用 ninja 构建系统
- 更好的 Android 兼容性

## 手动触发

在 GitHub Actions 页面选择工作流，点击 "Run workflow"，可选择指定版本号或留空自动检查最新版本。

## 本地使用

```bash
# 克隆仓库
git clone https://github.com/Alien-Et/nodejs.git
cd nodejs

# 手动触发工作流
gh workflow run build.yml --field node_version=24.0.0
# 或
gh workflow run build-termux.yml --field node_version=24.0.0
```

## 编译产物

编译完成后，二进制文件位于：
- `output/arm64/node-{版本号}-android-arm64`

## 使用方法

1. 下载对应架构的二进制文件
2. 赋予执行权限：`chmod +x node`
3. 运行：`./node --version`

## 技术规格

| 项目 | 标准方式 | Termux 方式 |
|------|---------|-------------|
| 目标架构 | arm64 (aarch64) | arm64 (aarch64) |
| 最低Android版本 | Android 7.0 (API 24) | Android 7.0 (API 24) |
| NDK版本 | r27d | r27d |
| 构建系统 | make | ninja |
| 补丁 | simdutf 修复 | Termux 官方补丁 |
| Node.js 版本 | v24+ | v24+ |

## 推荐使用

**推荐使用 `build-termux.yml`**，因为：
- 使用 Termux 官方维护的补丁
- 经过实际验证，兼容性更好
- 社区支持更完善

## 注意事项

- 此项目与 Node.js 官方项目无关联
- 编译产物仅包含 arm64 架构
- 编译产物为预发布版本 (prerelease)
