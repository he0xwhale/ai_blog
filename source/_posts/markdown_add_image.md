---
title: "Hexo 博客中插入本地图片的实践记录"
date: 2025-06-11 17:00:00
categories: 博客搭建
tags:
  - Hexo
  - Markdown
  - 插图
  - 博客技巧
headimg: /images/cover/local_image.jpg

---


## 🗃️ 图片存放位置的选择

我将图片统一放在了博客项目的 `source/images/` 目录下，这样在 Hexo 构建时会自动复制到 `public/images/` 中，路径清晰、引用方便。

## ✏️ Markdown 插图语法示例

在 Markdown 中插入图片，我采用的是标准语法：

```md
![评论区截图](/images/comment-preview.png)
```

图片路径是以 `/images/` 开头的绝对路径，对应的是构建后 `public/images/` 中的资源。

## 🔍 本地预览验证方法

执行以下命令后，可以本地预览：

```bash
hexo clean && hexo g && hexo s
```

浏览器打开 `http://localhost:4000/` 后，文章内图片能正常显示。也可以直接访问图片链接：

```
http://localhost:4000/images/comment-preview.png
```

如果图片能单独访问，但在文章里不显示，那就要检查是否用了相对路径、或者图片链接是否打错。

## ✅ 总结

Hexo 插图其实不复杂，只要把图片放在 `source/` 下，并使用正确路径，就可以稳定地显示。  
以后写文时，我都会统一放在 `source/images/`，省心不少。
