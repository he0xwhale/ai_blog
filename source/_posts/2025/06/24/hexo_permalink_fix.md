---

title: "Hexo 博客中 URL 路径出现重复日期的解决方案"

date: 2025-06-24 11:00:00

categories: 博客搭建


tags:

- Hexo
- Volantis
- 博客优化

headimg: /images/cover/hexo_permalink_fix.png
---

在使用 Hexo 搭建博客时，你可能会遇到如下问题：

> 文章的 URL 路径中出现了重复的日期字段，比如：
>
> ```
> http://localhost:4000/2025/06/24/2025/06/24/volantis_cyberpunk_style_avatar_bug/
> ```

这通常是由于文章的物理路径与 Hexo 的默认 `permalink` 规则叠加造成的，本文将介绍如何避免 URL 中重复的日期路径。

## 🚩 问题复现示例

假设文章的物理路径是：

```
source/_posts/2025/06/24/volantis_cyberpunk_style_avatar_bug.md
```

同时 Front Matter 中包含：

```yaml
date: 2025-06-24 10:00:00
```

而 Hexo 默认的 `permalink` 配置是：

```yaml
permalink: :year/:month/:day/:title/
```

此时构建出来的 URL 就会变成：

```
/2025/06/24/2025/06/24/volantis_cyberpunk_style_avatar_bug/
```

## ✅ 解决方案一：修改全局 permalink 配置 + 简化目录结构

1. 打开 Hexo 根目录下的 `_config.yml`；

2. 修改 `permalink` 设置：

   ```yaml
   permalink: :year/:month/:day/:title/
   ```

3. 移动你的文章 `.md` 文件至 `_posts/` 根目录：

   ```bash
   mv source/_posts/2025/06/24/volantis_cyberpunk_style_avatar_bug.md source/_posts/
   ```

最终构建出来的 URL：

```
/2025/06/24/volantis_cyberpunk_style_avatar_bug/
```

### 如果你不想保留日期路径：

将 `_config.yml` 中的 permalink 改为：

```yaml
permalink: :title/
```

则构建 URL 为：

```
/volantis_cyberpunk_style_avatar_bug/
```

## ✅ 解决方案二：为单篇文章自定义 permalink

如果你只想修改某篇文章的访问路径，可以在其 Front Matter 中手动设置：

```yaml
permalink: /2025/06/24/volantis_cyberpunk_style_avatar_bug/
```

这样就不会受物理路径和全局 permalink 设置的影响，Hexo 将使用你指定的 URL。

## ✅ 总结对比

| 方法                                   | 操作                   | 适用范围 | 效果            |
| ------------------------------------ | -------------------- | ---- | ------------- |
| 修改 `_config.yml` 配置 + 整理 `_posts` 结构 | 修改 `permalink` 并搬移文章 | 全局生效 | 清晰、统一的 URL 路径 |
| 为单篇文章设置 `permalink`                  | 修改文章 Front Matter    | 局部定制 | 灵活配置路径        |

---

希望本文能帮你清理掉 URL 中冗余的日期路径，保持博客结构清晰简洁。\
如果你想要我自动批量调整历史文章结构或生成脚本，请留言交流！

