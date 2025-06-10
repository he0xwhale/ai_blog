# AI 编程风格的吉卜力风博客

> 一个基于 Hexo + Volantis 主题的个人博客，融合了 AI 编程与吉卜力风格的设计元素。

## 🌟 特点

- 基于 Hexo 6.3.0+ 构建
- 使用 Volantis 主题（Git 子模块方式管理）
- AI 编程风格与吉卜力动画风格的融合设计
- 字体图标本地化，提升加载速度
- 自动部署到 GitHub Pages
- 开发环境支持热更新

## 🚀 快速开始

### 环境要求

- Node.js (推荐 14.0.0 或更高版本)
- Git

### 安装步骤

1. 克隆项目：
```bash
git clone --recursive https://github.com/your-username/ai_blog.git
cd ai_blog
```

2. 安装依赖：
```bash
npm install
```

3. 本地预览：
```bash
hexo s --draft --open
```

### 部署

使用自动部署脚本：

```bash
./deploy.sh
```

## 📁 项目结构

```
.
├── _config.yml           # Hexo 配置文件
├── _config.volantis.yml  # Volantis 主题配置
├── source/              # 博客文章和资源
│   ├── _posts/         # 博客文章
│   └── images/         # 图片资源
├── themes/             # 主题目录
│   └── volantis/      # Volantis 主题（子模块）
└── deploy.sh          # 自动部署脚本
```

## 🔧 自定义配置

### 主题配置

编辑 `_config.volantis.yml` 文件来自定义：

- 网站 Logo
- 导航栏
- 侧边栏
- 背景图片
- 字体设置

### 字体图标

所有字体图标已本地化，存放在 `themes/volantis/source/webfonts/` 目录下。

## 🤝 贡献

欢迎提交 Issue 和 Pull Request。

## 📝 许可证

本项目采用 [MIT 许可证](LICENSE)。

## 🌐 在线预览

访问 [https://ai.he0xwhale.xyz](https://ai.he0xwhale.xyz) 查看博客效果。