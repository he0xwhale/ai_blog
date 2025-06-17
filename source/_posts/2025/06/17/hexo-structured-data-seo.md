---
title: "Hexo 博客结构化数据（SEO）配置实践记录"
date: 2025-06-16 10:30:00 +0800
categories: 博客搭建
tags:
  - SEO
  - Hexo
  - 结构化数据
  - Volantis
---

为了提升博客在搜索引擎中的表现，我对博客添加了结构化数据支持，记录如下配置过程及排查经验，供他人参考。

## 一、背景

Hexo 博客采用 Volantis 主题，默认已支持结构化数据（Structured Data），但初始配置使用的是 `https://schema.org.cn`，在 [Google 富媒体搜索结果测试](https://search.google.com/test/rich-results) 中检测不到结构化数据内容。

## 二、初步排查

通过对博客生成的 HTML 文件进行搜索：

```bash
grep -r "https://schema.org.cn" public/
```

发现包含如下结构：

```html
<body itemscope itemtype="https://schema.org.cn/WebPage">
<header itemscope itemtype="https://schema.org.cn/WPHeader">
<article itemscope itemtype="https://schema.org.cn/Article">
...
<script type="application/ld+json">
  {"@context": "https://schema.org.cn", "@type": "Organization", ...}
</script>
```

## 三、分析与修复

虽然 `schema.org.cn` 域名可解析，但并非 Google 官方推荐或认可的结构化数据源。正确做法应使用 `https://schema.org`。

### 解决方案：

使用以下命令在博客根目录（建议包括 `themes/volantis/`、`source/`、`layout/` 等）替换所有 `schema.org.cn` 为 `https://schema.org`：

```bash
find . -type f -name "*.html" -o -name "*.ejs" -o -name "*.js" | xargs sed -i 's|https://schema.org.cn|https://schema.org|g'
```

或若使用 VSCode，可全局搜索 `schema.org.cn` 替换为 `schema.org`。

## 四、验证效果

### 测试工具

- Google 富媒体搜索结果测试：  
  [https://search.google.com/test/rich-results](https://search.google.com/test/rich-results)

替换为 `https://schema.org` 后再次测试，成功识别如下结构化数据：

- `Organization`
- `Person`
- `BlogPosting`
- `BreadcrumbList`
- `WebSite`

### 说明

Volantis 主题 `/_config.yml` 中默认已支持这些结构化类型，相关文档如下：

```yaml
############################### Structured Data ############################### > start
# SEO 入门文档: https://developers.google.com/search/docs
# https://schema.org/
# 结构化数据用于更改搜索结果的显示效果
# 目前内置的结构化数据: blogposting, breadcrumblist, organization, person, website
```

## 五、搜索控制台仍未显示索引？

虽经结构化数据修复，但在 [Google Search Console](https://search.google.com/search-console) 中仍未看到索引信息，可能是：

- Google 尚未重新抓取页面；
- 站点地图提交不完整；
- robots.txt 设置有误；
- 搜索引擎优化整体还不充分。

**当前暂未深入处理此问题，后续视情况更新索引优化策略。**

## 六、小结

结构化数据是 SEO 中重要一环，尤其适用于博客类内容。此次实践证明：

- 使用 Google 官方 `https://schema.org` 是确保被识别的关键；
- Hexo + Volantis 主题原生已支持结构化数据，细节需手动微调；
- 正确配置后能通过富媒体测试验证，提升搜索可视性。

---

> 💡 建议后续配合 robots.txt、站点地图、Search Console 提交等方式，持续完善博客 SEO。
