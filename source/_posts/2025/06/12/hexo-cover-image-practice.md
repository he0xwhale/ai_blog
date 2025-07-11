---
title: "Hexo 博客中为文章添加封面图的实践记录"
date: 2025-06-12 15:00:00
categories:
  - 博客之旅
  - 基础搭建
tags:
  - Hexo
  - Volantis
  - 博客封面图
  - 实践记录
cover: /images/cover/cover_record.jpg
---

## 1. 写在前面

在搭建 Hexo 博客的过程中，我一直希望文章列表能更美观一些。特别是首页的文章卡片，如果能加上一张封面图，整体效果会更加吸引人。于是我着手尝试为文章添加封面图，并记录下这个过程，希望对同样使用 Volantis 主题的朋友有所帮助。

## 2. 封面图功能的支持背景

我使用的是 Hexo + Volantis 主题，发现主题的文章预览卡片中，实际上是支持封面图显示的。只是这一功能并不默认开启，也没有在文档中有明显说明，需要我们自己手动配置。

在文章的 front-matter 中加入headimg字段，就可以控制每篇文章的封面图显示。

## 3. 添加封面图的方法

在每篇 Markdown 文章的开头（也就是 front-matter 区域），添加 `headimg` 字段即可。

比如：

```
---
title: Hexo 博客封面图测试
date: 2025-06-10 16:20:00
tags:
  - 博客测试
cover: /images/test-cover.jpg
---
```

> 💡 图片路径推荐放在 `source/images/` 目录中，发布后可通过 `/images/xxx.jpg` 的形式引用。

## 4. 封面图排查与验证过程

一开始，我在文章中添加了 `cover` 字段，却没有显示封面图。于是我开始了排查过程：

### 4.1 从 layout 开始追查

我打开了主题中的 `layout/index.ejs` 文件，发现它引用了 `_partial/archive` 模板：

```ejs
<%- partial('_partial/archive') %>
```

### 4.2 查看 _partial/archive.ejs

在 `archive.ejs` 中，每一篇文章都通过如下方式渲染：

```ejs
<%- partial('post', {post: post}) %>
```

### 4.3 最终定位到 post.ejs

在 `post.ejs` 中，我看到了如下片段：

```ejs
<% if (post.headimg) { %>
  <img src="<%- post.headimg %>" ... />
<% } %>
```

这时候我才意识到，原来 Volantis 主题是通过 `headimg` 字段来识别封面图的。

于是我把 front-matter 中的 `cover` 改成了 `headimg`，问题就解决了！

## 5. 最终效果与小结

现在，我的博客首页已经成功地为每篇文章展示封面图了。效果如下：
![增加了文章封面图](../images/headimg_add.png)

- 图片大小自动适配卡片宽度
- 支持本地图片引用（推荐放到 `source/images/` 目录）
- 不需要修改任何模板，只需配置 `headimg` 字段即可

### 5.1 使用建议

- 每篇文章的封面图尽量统一尺寸，保持视觉一致性
- 可以使用 Gork、Canva 等工具快速生成封面图
- 如果有自动化需求，也可以结合脚本为旧文章批量添加封面字段

希望这篇记录对你有所帮助！