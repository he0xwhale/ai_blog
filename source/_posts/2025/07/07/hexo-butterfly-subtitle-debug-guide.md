---
title: Hexo Butterfly 主题副标题不显示问题排查与解决
date: 2025-07-07 16:30:00
tags:
  - Hexo
  - Butterfly
  - Debugging
  - Configuration
  - Front-end
cover: /images/cover/hexo-butterfly-subtitle-debug-guide.png
---


### 引言

在使用 Hexo 搭建博客并采用 Butterfly 主题时，您可能会遇到一个令人困惑的问题：网站的 `<title>` 标签中正确显示了站点标题和副标题（例如 "AI whale - Exploring the World of AI"），但在实际的页面内容（尤其是首页的头部区域）中，却只显示了站点标题，而副标题神秘“失踪”了。本文将详细记录这一问题的排查过程，并提供最终的解决方案。

### 问题现象

在浏览器中检查网站首页的 HTML 元素，可以发现 `<head>` 标签内的 `<title>` 元素内容是完整的：

```html
<title>AI whale - Exploring the World of AI</title>
```

然而，在 `<body>` 内部的可见区域，例如 `<header>` 部分，却只有主标题“AI whale”显示，副标题“Exploring the World of AI”不见踪影。

### 排查过程

1.  **检查全局配置 (`_config.yml`)**
    首先，我们检查了 Hexo 的全局配置文件 `_config.yml`，确认 `title` 和 `subtitle` 配置项都已正确设置：

    ```yaml
    # _config.yml
    title: AI whale
    subtitle: "Exploring the World of AI"
    ```

    这表明网站的元信息是正确的，问题可能出在主题的渲染逻辑上。

2.  **定位主题配置文件 (`themes/butterfly/_config.yml`)**
    Hexo 主题通常有自己的配置文件，这些配置会覆盖或合并全局配置。对于 Butterfly 主题，其配置文件位于 `themes/butterfly/_config.yml`。我们检查了该文件，发现了 `subtitle` 相关配置：

    ```yaml
    # themes/butterfly/_config.yml
    # ...
    subtitle:
      enable: true
      effect: true # 启用打字机效果
      # ...
      sub:
        - "从传统编程到AI编程，一刻不停的疲于奔命"
    # ...
    ```

    这里注意到 `subtitle` 被定义为一个对象，其中 `enable` 为 `true`，并且 `sub` 数组中包含了另一个字符串，而不是全局 `_config.yml` 中的“Exploring the World of AI”。

3.  **分析主题渲染逻辑 (`themes/butterfly/layout/includes/header/index.pug` 和 `themes/butterfly/layout/includes/third-party/subtitle.pug`)**
    我们进一步深入主题的模板文件，发现主页头部渲染逻辑位于 `themes/butterfly/layout/includes/header/index.pug`：

    ```pug
    // themes/butterfly/layout/includes/header/index.pug
    // ...
    else if globalPageType === 'home'
      #site-info
        h1#site-title=config.title
        if theme.subtitle.enable // 条件判断
          - var loadSubJs = true
          #site-subtitle
            span#subtitle // 副标题占位符
    // ...
    ```

    而 `span#subtitle` 的内容填充则是由 `themes/butterfly/layout/includes/third-party/subtitle.pug` 中的 JavaScript 动态完成的。关键在于该文件中的逻辑：

    ```pug
    // themes/butterfly/layout/includes/third-party/subtitle.pug
    - const { effect, source, sub, typed_option } = theme.subtitle
    // ...
    script.
      window.typedJSFn = {
        init: str => {
          // ... (Typed.js 初始化逻辑)
        },
        run: subtitleType => {
          // ...
        },
        processSubtitle: (content, extraContents = []) => {
          if (!{effect}) { // 如果 effect 为 false，使用 Typed.js
            // ...
          } else { // 如果 effect 为 true，直接设置 textContent
            document.getElementById('subtitle').textContent = typeof content === 'string' ? content :
              (Array.isArray(content) && content.length > 0 ? content[0] : '')
          }
        }
      }
    // ...
    ```

    我们发现，如果 `theme.subtitle.effect` 为 `true`，则会直接从 `theme.subtitle.sub` 数组中获取第一个元素作为副标题文本。

4.  **发现配置冲突**
    问题浮出水面：Hexo 在合并全局 `_config.yml` 和主题 `_config.butterfly.yml` 时，对于 `subtitle` 这个配置项，并没有进行深层合并 (deep merge)，而是简单地用全局 `_config.yml` 中 `subtitle` 的字符串值（"Exploring the World of AI"）覆盖了主题 `_config.butterfly.yml` 中 `subtitle` 的整个对象。

    这意味着，当 Pug 模板尝试访问 `theme.subtitle.enable` 或 `theme.subtitle.sub` 时，它实际上是在尝试访问字符串 `"Exploring the World of AI"` 的属性，这必然导致 `undefined` 或错误。因此，`if theme.subtitle.enable` 条件始终为 `false`，导致副标题的 HTML 结构和 JavaScript 逻辑都没有被渲染到最终的 `public/index.html` 中。

    通过在 Pug 模板中输出 `theme` 对象的完整 JSON 字符串，我们证实了这一点：`"subtitle": "Exploring the World of AI"` 确实是 `theme` 对象中 `subtitle` 的实际值。

### 解决方案

根本原因是 Hexo 配置的合并机制。要解决此问题，需要确保主题的 `subtitle` 配置能够正确被解析。

**最直接的解决方案是：**

将 Hexo 全局配置文件 (`_config.yml`) 中的 `subtitle` 配置项移除或注释掉。

```yaml
# _config.yml
title: AI whale
# subtitle: "Exploring the World of AI" # 注释掉或删除此行
```

通过这样做，Hexo 在生成静态文件时，将不再有全局的 `subtitle` 字符串来覆盖主题的 `subtitle` 对象。这样，主题 `themes/butterfly/_config.yml` 中定义的 `subtitle` 对象（包括 `enable: true` 和 `sub` 数组）就会被正确加载和使用，从而使得副标题能够正常显示。

### 总结

本次排查的核心在于理解 Hexo 配置文件的合并机制以及主题渲染逻辑对配置项的依赖。当全局配置与主题配置存在同名但不同类型（字符串 vs. 对象）的配置项时，Hexo 会优先使用全局配置，导致主题的复杂配置无法生效。通过移除冲突的全局配置，我们成功地让主题的副标题功能恢复正常。