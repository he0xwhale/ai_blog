---
title: 一次因缓存引发的“灵异事件”：Hexo Butterfly 主题封面图调试全记录
date: 2025-07-09 15:45:00
tags:
  - Hexo
  - Butterfly
  - Debugging
  - 踩坑记录
  - 前端调试
categories:
  - 博客之旅
  - 问题排查
cover: /images/cover/hexo-butterfly-cover-image-debug-story.png
---

> 在搭建和美化 Hexo 博客的过程中，我们时常会遇到一些看似简单，却足以让人抓狂的“灵异事件”。最近，我就和我的 AI 助手 Roo 经历了一次这样的封面图调试之旅。一个简单的图片不显示问题，我们排查了代码、配置、路径，甚至怀疑人生，最终却发现“真凶”隐藏在一个意想不到的地方。

这篇文章记录了我们完整的调试过程，希望能为同样在 Hexo 世界中探索的你提供一些有价值的参考和避坑指南。

---

### **📌 重要更新与注意事项（2025-07-11）**

在 Pull Request 中，我得到了主题作者的反馈，这修正了我对 `themes/butterfly/_config.yml` 中 `category_img` 和 `tag_img` 配置项的理解。

**最初的误解：** 本文最初的问题提出（“不听话的 `category_img` 和 `tag_img`”）是基于一个误解，认为 `category_img` 和 `tag_img` 是用于设置分类页 `/categories/` 和标签页 `/tags/` 主页的封面图。

**正确的理解：**
*   `category_img` 和 `tag_img` 配置项，实际上是用于设置**当文章没有指定 `cover` 时，其所属分类或标签页的**默认封面图。换句话说，它们是为**文章**（posts）在分类/标签归档页面中提供一个备用的封面图，而不是为 `/categories/` 或 `/tags/` 这些**主归档页面**设置封面。
*   **分类页 `/categories/` 和标签页 `/tags/` 的主封面图，应该在它们各自的 Markdown 文件（例如 `source/categories/index.md` 和 `source/tags/index.md`）的 Front-matter 中通过 `top_img` 属性来配置。**



---

### 一、问题的提出：对 `category_img` 和 `tag_img` 的误解

最初的问题很简单：我为分类页和标签页设置了封面图，但它们就是不显示。

在 `themes/butterfly/_config.yml` 中，我的配置如下：

```yaml
# ...
# If the banner of page not setting, it will show the default_top_img
default_top_img:

# ...
# Note: category page, not categories page
category_img: /images/website/categories.png

# Note: tag page, not tags page
tag_img: /images/website/tag.png
# ...
```

奇怪的是，如果我设置了 `default_top_img`，比如：

```yaml
default_top_img: /images/website/bg.png
```

那么分类页和标签页就会显示 `bg.png` 这张图片。这说明页面本身能够显示封面图，但 `category_img` 和 `tag_img` 这两个配置项被无视了。

### 二、初步排查：代码逻辑的“完美无缺”

我们首先进行了一系列常规的代码层面排查：

1.  **检查文件是否存在**：确认 `/source/images/website/categories.png` 和 `/source/images/website/tag.png` 这两个图片文件确实存在。
2.  **检查模板逻辑**：我们深入分析了 Butterfly 主题的核心模板文件 `themes/butterfly/layout/includes/header/index.pug`。通过分析，我们确定了封面图的渲染逻辑。
3.  **调试页面变量**：通过在模板中输出调试信息，我们发现了一个关键信息：在分类页（`/categories/`），Hexo 传递给模板的变量 `page.type` 的值是 `categories`，但主题内部计算出的 `globalPageType` 却是 `page`。

基于这个发现，我们修正了 `header/index.pug` 的代码，在 `case globalPageType` 的 `when 'page'` 分支中，增加了对 `page.type` 的判断：

```pug
// themes/butterfly/layout/includes/header/index.pug
// ...
    when 'page'
      if page.type === 'categories'
        - top_img = returnTopImg(theme.category_img)
      else if page.type === 'tags'
        - top_img = returnTopImg(theme.tag_img)
      else
        - top_img = page.top_img || theme.default_top_img
// ...
```

这段代码的逻辑非常清晰：当页面类型是 `page` 时，再检查其具体的 `type` 属性，如果是 `categories` 或 `tags`，就使用对应的图片。

至此，我们确信代码逻辑已经完美。

### 三、陷入僵局：当 `hexo clean` 也不管用时

然而，最诡异的事情发生了。尽管我们每次修改后都严格执行了 `hexo clean` 来清除缓存，并使用 `Ctrl+Shift+R` 硬刷新浏览器，但问题依旧。图片依然不显示，就好像我们的代码修改从未发生过一样。

这让我们一度怀疑是 Pug 模板引擎的渲染问题，甚至尝试了用 JavaScript 动态修改 `style` 属性等各种“曲线救国”的方法，但都无济于事。

### 四、最终突破：重启 `hexo server` 后的“豁然开朗”

就在我们几乎要放弃的时候，转机出现了。~~第二天，我重启了电脑，~~再次运行 `hexo server`，然后惊奇地发现——一切都正常了！分类页和标签页的封面图都正确地显示了出来。

**这让我们最终定位到了问题的根本原因：Hexo 渲染进程的陈旧缓存。**

经过后续的验证，我们发现之前的代码修改是完全正确的，只是需要**彻底重启 `hexo server` 服务**才能让新的模板逻辑生效。


*   **`hexo clean` 的局限性**：这个命令确实可以清除 `public` 目录和物理的 `db.json` 缓存文件。但是，它**无法重置正在运行的 `hexo server` 进程的内存状态**。
*   **`hexo server` 的“幽灵”状态**：在我们长时间、高强度的调试过程中，对主题的模板文件 (`.pug`) 和辅助函数 (`.js`) 进行了大量修改。这很可能导致了 `hexo server` 的 Node.js 进程内部状态变得不一致。它可能没有完全重新加载所有模块，或者某些变量的缓存在内存中没有被正确清除。
*   **重启的威力**：~~重启电脑彻底终止了所有进程，包括那个可能已经“精神错乱”的 `hexo server` 进程。~~ **停止并重启 `hexo server`** 会终结旧的 Node.js 进程。当我们再次启动服务时，一个全新的、干净的进程会加载所有最新的、正确的代码和配置，问题自然就迎刃而解了。

### 五、经验总结与操作建议

这次漫长而曲折的调试过程，给我们带来了宝贵的经验：

1.  **养成 `hexo clean` 的好习惯**：在修改任何配置或代码后，执行 `hexo clean` 永远是第一选择。
2.  **重启 `hexo server` 是必要的**：当你修改了主题的 `.js` 逻辑文件或 `.pug` 模板文件后，如果 `hexo clean` 不起作用，请务必**停止 (`Ctrl+C`) 并重新启动 `hexo server`**。这会强制 Hexo 加载一个全新的、干净的运行环境。
3.  **浏览器缓存不可忽视**：在开发时，善用 `Ctrl+Shift+R` 硬刷新或在开发者工具中禁用缓存。
4.  **页面封面图的正确设置**：
    *   **独立页面（如“关于”、“友链”）**：在对应的 Markdown 文件 (`source/about/index.md`, `source/friends/index.md`) 的 **Front-matter** 中添加 `top_img` 属性来单独指定封面图。
    *   **分类页 `/categories/` 和标签页 `/tags/` 主页**：同独立页面一样，在各自的 Markdown 文件 (`source/categories/index.md`, `source/tags/index.md`) 的 **Front-matter** 中通过 `top_img` 属性来配置。
    *   **`_config.yml` 中的 `category_img` 和 `tag_img`**：这些配置项是为**文章**（posts）在其所属分类或标签归档页面中提供一个**备用**的封面图，而不是为 `/categories/` 或 `/tags/` 主页设置封面。

希望这次的“灵异事件”记录，能帮助你在 Hexo 的世界里少走一些弯路。