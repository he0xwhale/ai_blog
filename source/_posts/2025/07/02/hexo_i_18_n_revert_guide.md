---
title: 从 Hexo 国际化配置还原为默认状态（Volantis 主题完整修复指南）
date: 2025-07-02 
categories:
  - 博客之旅
  - 问题排查
tags:
- Hexo
- Volantis
- 博客搭建
- 多语言
- 排障记录
- Hexo
- Volantis
- i18n
- 国际化
- 博客恢复
cover: /images/cover/hexo_i_18_n_revert_guide.png

---

>  在尝试为 Hexo 博客启用多语言功能，搭配 Volantis 主题与 `hexo-generator-index-i18n` 插件实现 `/` 显示 zh-CN，`/en/` 显示英文分页的过程中，出现了大量错误
  - 首页 `Cannot GET /`
  - `/zh-CN/zh-CN/index.html` 等路径嵌套
  - 所有文章混杂分页、不正确语言过滤
  - 页码仍基于总文章数分页（比如 1/4）

  最终我决定**完全撤销国际化支持，恢复 Hexo + Volantis 默认行为**，并记录完整还原过程，方便自己或他人参考。

---

## 💡 尝试 Hexo 多语言支持过程（失败记录）

### 1. 使用 `hexo-generator-index-i18n`

在根目录 `_config.yml` 添加配置：

```yaml
index_generator_i18n:
  per_page: 10
  order_by: -date
  languages:
    zh-CN: index    # 期望生成 /index.html
    en: en          # 生成 /en/index.html
```

文章结构使用 `source/_posts/zh-CN/` 和 `source/_posts/en/`。 文章 front-matter 添加 `lang: zh-CN` 或 `lang: en`。

**结果：**

- 多语言页面能访问 `/zh-CN/` 和 `/en/`
- 但根目录 `/` 不会列出全部文章，且分页逻辑混乱
- `/public/zh-CN/zh-CN/index.html` 这种嵌套出现，路径异常

### 2. 修改 `archive.ejs` 与 `index.ejs` 模板

尝试用 `page.lang` 对文章进行语言过滤：

```ejs
const currentLang = page.lang || 'zh-CN';
...
site.posts.filter(post => post.lang === currentLang)
```

**结果：**

- 文章确实被筛选了，但分页总数仍为全局文章数
- 出现 `1/4` 页码，但其实该语言下只有 1 篇文章

### 3. 使用 HTML 重定向方案

尝试添加 `source/index.html`：

```html
<meta http-equiv="refresh" content="0; url=/zh-CN/">
```

**结果：** 无效，Hexo build 后根路径仍无首页，或被清空

### 4. 使用 `hexo-generator-redirect` 插件

```bash
npm install hexo-generator-redirect --save
```

然后配置：

```yaml
redirects:
  "/": "/zh-CN/"
```

**结果：** 安装失败（依赖 Hexo 5，当前为 Hexo 6.3），或 `/` 页面失效（Cannot GET /）

最终，在对 Hexo、Volantis、分页插件等源码调试后，判断国际化插件目前与 Volantis 的首页分页机制冲突过多，决定**彻底撤回**。

---

## ✅ 恢复操作步骤

### 1. 还原根目录 `_config.yml` 配置

删除国际化相关配置：

```yaml
index_generator_i18n: ...    # ❌ 删除
language: zh-CN              # ✅ 设置默认语言
index_generator:             # ✅ 使用默认分页生成器
  path: ''
  per_page: 10
  order_by: -date
```

### 2. 卸载国际化插件

```bash
npm uninstall hexo-generator-index-i18n
npm uninstall hexo-generator-redirect
npm install hexo-generator-index
```

### 3. 合并文章结构

```bash
mv source/_posts/zh-CN/* source/_posts/
mv source/_posts/en/* source/_posts/
rm -r source/_posts/zh-CN/
rm -r source/_posts/en/
```

删除每篇文章的 `lang:` 字段（可选）

### 4. 删除语言静态页面及 index.html

```bash
rm -rf source/en/ source/zh-CN/
rm -f source/index.html source/index.md
```

### 5. 恢复 Volantis 模板

将 `themes/volantis/layout/_partial/archive.ejs` 文件内容还原为原始：

```ejs
<% if (site.posts && site.posts.length > 0) { %>
<section class="post-list">

  <% if (page.current === 1) { %>
    <% site.posts.filter(post => post.pin).sort('date', -1).each(function(post){ %>
      <div class='post-wrapper'>
        <%- partial('post', {post: post}) %>
      </div>
    <% }) %>
    <% site.pages.filter(post => post.pin).sort('date', -1).each(function(post){ %>
      <div class='post-wrapper'>
        <%- partial('post', {post: post}) %>
      </div>
    <% }) %>
  <% } %>

  <% page.posts.filter(post => !post.pin).each(function(post){ %>
    <div class='post-wrapper'>
      <%- partial('post', {post: post}) %>
    </div>
  <% }) %>

</section>
  <% if (page.total > 1) { %>
    <br>
    <div class="prev-next">
      <% if (page.prev != 0) { %>
        <a class="prev" rel="prev" href="<%= url_for(page.prev_link) %>">
          <section class="post prev white-box <%- theme.custom_css.body.effect.join(' ') %>">
            <i class="fa-solid fa-chevron-left" aria-hidden="true"></i>&nbsp;<%- __('post.prev_page') %>&nbsp;
          </section>
        </a>
      <% } %>
      <p class="current">
        <%= page.current %> / <%= page.total %>
      </p>
      <% if (page.next != 0) { %>
        <a class="next" rel="next" href="<%= url_for(page.next_link) %>">
          <section class="post next white-box <%- theme.custom_css.body.effect.join(' ') %>">
            &nbsp;<%- __('post.next_page') %>&nbsp;<i class="fa-solid fa-chevron-right" aria-hidden="true"></i>
          </section>
        </a>
      <% } %>
    </div>
  <% } %>
<% } %>
```

### 6. 重新构建

```bash
hexo clean && hexo g && hexo s
```

---

## ✅ 最终恢复效果

| 功能               | 状态                 |
| ---------------- | ------------------ |
| 首页 /             | ✅ 显示所有文章，不再跳转      |
| `/zh-CN/`、`/en/` | ❌ 不再存在             |
| 分页               | ✅ 按总文章数分页          |
| 模板               | ✅ 使用 Volantis 默认逻辑 |

---

## 📌 总结

Hexo 当前的分页逻辑与 Volantis 的模板结构，在使用 `hexo-generator-index-i18n` 时存在以下问题：

1. `page.posts` 提供的是全局文章数组，分页数量基于所有文章
2. 即便筛选文章显示了部分，分页导航仍照旧分页（出现 1/4，2/4）
3. Volantis 模板未内建对多语言分页路径的完整支持
4. 插件本身未适配 Hexo 6.x + Volantis 最新模板结构

⚠️ 建议未来如需中英文独立首页分页，可以考虑：

- 使用多 Hexo 子站部署
- 使用标签（如 `tag: en`）做筛选页
- 自定义 index 页 + layout

---

希望本文对未来再次尝试 Hexo 多语言配置有所帮助，也欢迎基于此模板进一步扩展语言支持方案。

