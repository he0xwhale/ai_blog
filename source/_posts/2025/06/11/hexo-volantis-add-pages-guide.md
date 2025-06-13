---
title: "Hexo 博客中添加分类、标签、关于、友链页面的完整教程（Volantis 主题）"
date: 2025-06-11 12:00:00
categories: 博客搭建
tags:
  - Hexo
  - Volantis
  - 博客页面
  - 分类标签
  - 友链页面
headimg: /images/cover/hexo-volantis-add-pages-guide.jpg
---
# Hexo Volantis 添加常用页面指南

## 前言
在搭建 Hexo 博客并使用 Volantis 主题时，很多人会遇到访问 `/categories/`、`/tags/`、`/about/` 或 `/friends/` 页面时提示 `Cannot GET` 的问题。本文将手把手教你如何手动添加这些页面并正确配置它们的 front-matter，从而让博客结构更完整，功能更齐全。

## 一、添加分类页面（/categories/）

### 1. 安装插件（如未安装）
```bash
npm install hexo-generator-category --save
```

### 2. 创建页面
```bash
hexo new page categories
```

### 3. 修改 front-matter
编辑 `source/categories/index.md` 内容如下：

```yaml
---
layout: category
index: true
title: 分类
---
```

### 4. 重建博客
```bash
hexo clean && hexo g && hexo s
```

### 5. 访问验证
浏览器访问：http://localhost:4000/categories/

## 二、添加标签页面（/tags/）

### 1. 创建页面
```bash
hexo new page tags
```

### 2. 修改 front-matter
编辑 `source/tags/index.md` 内容如下：

```yaml
---
layout: tag
index: true
title: 标签
---
```

### 3. 重新生成并访问
```bash
hexo clean && hexo g && hexo s
```
访问：http://localhost:4000/tags/

## 三、添加关于页面（/about/）

### 1. 创建页面
```bash
hexo new page about
```

### 2. 编辑 front-matter 和正文
```yaml
---
title: 关于我
layout: page
---

你好，我是 XXX。欢迎来到我的博客。
```

### 3. 访问验证
浏览器访问：http://localhost:4000/about/

## 四、添加友链页面（/friends/）

### 1. 创建页面
```bash
hexo new page friends
```

### 2. 编辑 front-matter 和内容
```yaml
---
title: 友链
layout: page
comments: false
---

欢迎交换友链，请留言或联系我。

## 友情链接

- [Hexo 官方文档](https://hexo.io/)
- [Volantis 主题文档](https://volantis.js.org/)
```

### 3. 可选：使用卡片式展示
Volantis 支持自定义 `friends.yml` 数据文件，可配合自定义模板实现卡片式展示。

## 五、常见问题与总结

### 页面生成了但访问仍然报错？
请检查：
- `source/xxx/index.md` 文件是否存在
- front-matter 是否写错字段（必须包含 `layout: xxx` 和 `index: true`）
- 是否执行了 `hexo clean && hexo g`

### Volantis 支持的 layout 对照表：

| 页面类型 | layout 值 |
|----------|-----------|
| 分类页   | category  |
| 标签页   | tag       |
| 关于页   | page      |
| 友链页   | page      |

## 附录：页面文件结构参考

```
source/
├── about/
│   └── index.md
├── categories/
│   └── index.md
├── tags/
│   └── index.md
├── friends/
│   └── index.md
```

生成后的页面会在 `public/` 目录中对应生成。
