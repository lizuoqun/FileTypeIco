# FileTypeIco

<p align="center">
    <img src="public/logo.png" alt="FileTypeIco Logo" width="128" height="128">
</p>

一款基于 Vue3 和 Electron 开发的桌面软件，用于便捷快速修改文件夹图标，实现文件夹自定义。

## 功能特性
- **快速修改图标**：支持一键修改文件夹图标。
- **图标库丰富**：内置多种精美图标，也支持自定义上传图标。
- **多平台支持**：支持 Windows、macOS 和 Linux 系统。
- **操作简单**：简洁直观的用户界面，轻松上手。

## 安装使用
### 环境准备
- Node.js (v22.9.0)
- npm (v10.8.3)

### 安装依赖
```bash
npm install
```

### Development

```bash
$ npm run dev
```

### Build

```bash
# For windows
$ npm run build:win

# For macOS
$ npm run build:mac

# For Linux
$ npm run build:linux
```

## 界面操作指南
1. 打开软件后，点击 `选择文件夹` 按钮，选择需要修改图标的文件夹。
2. 从内置图标库中选择喜欢的图标，或点击 `上传图标` 按钮上传自定义 PNG 图标。
3. 点击 `应用图标` 按钮，完成文件夹图标修改。

## 技术栈
- **前端框架**：Vue3 + TypeScript
- **桌面应用框架**：Electron
- **构建工具**：Vite
- **代码规范**：ESLint + Prettier

## 推荐 IDE 配置
- [VSCode](https://code.visualstudio.com/) + [ESLint](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint) + [Prettier](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode) + [Volar](https://marketplace.visualstudio.com/items?itemName=Vue.volar)

## 贡献指南
如果你想为项目做出贡献，请参考以下步骤：
1. Fork 本仓库。
2. 创建你的特性分支 (`git checkout -b feature/AmazingFeature`)。
3. 提交你的修改 (`git commit -m 'Add some AmazingFeature'`)。
4. 将分支推送到远程仓库 (`git push origin feature/AmazingFeature`)。
5. 打开 Pull Request。

## 许可证
本项目采用 [MIT 许可证](LICENSE)。