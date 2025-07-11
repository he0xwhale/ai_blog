# Volantis主题自定义配置移植到Butterfly主题的计划

我已经分析了您在Volantis主题中的自定义配置，并与Butterfly主题的配置进行了初步对比。以下是将Volantis主题的自定义配置移植到Butterfly主题的详细计划：

## 1. 导航栏 (Navbar) 配置
- **Volantis配置**：自定义了导航栏菜单项，包括“博客”、“分类”、“标签”、“归档”、“友链”、“关于”和“English”等，设置了图标和链接。
- **Butterfly配置**：需要在 `_config.butterfly.yml` 中找到对应的导航栏配置部分，添加类似的菜单项。
- **移植步骤**：
  1. 在Butterfly配置文件中找到 `menu` 或类似的导航栏配置项。
  2. 添加Volantis中定义的菜单项，调整格式以适应Butterfly的要求，可能需要参考Butterfly主题的文档来设置图标。

## 2. 封面 (Cover) 配置
- **Volantis配置**：设置了封面高度、布局方案、背景图片、标题和副标题等。
- **Butterfly配置**：Butterfly可能有不同的封面或首页布局设置，需要找到对应的配置项。
- **移植步骤**：
  1. 在Butterfly配置文件中找到首页或封面相关的配置。
  2. 设置背景图片为 `/images/bg.png`，标题为“夹缝中的AI编程者”，副标题为“从传统编程到AI编程，一刻不停的疲于奔命”。
  3. 根据Butterfly的选项调整布局方案，可能需要选择类似的“搜索”或“焦点”布局。

## 3. 文章布局 (Article Layout) 配置
- **Volantis配置**：定义了文章预览和正文的布局，包括顶部和底部元信息、页脚组件等。
- **Butterfly配置**：Butterfly可能有类似的文章布局设置，需要找到对应选项。
- **移植步骤**：
  1. 在Butterfly配置文件中找到文章布局相关的配置。
  2. 设置顶部元信息为作者、分类、日期、字数统计等。
  3. 设置底部元信息为更新日期、标签、分享等。
  4. 检查是否可以启用类似Volantis的推荐文章或相关文章组件。

## 4. 评论系统 (Comments) 配置
- **Volantis配置**：使用Giscus作为评论系统，配置了仓库信息、类别、语言等。
- **Butterfly配置**：Butterfly支持多种评论系统，需要找到Giscus的配置选项。
- **移植步骤**：
  1. 在Butterfly配置文件中找到评论系统配置部分。
  2. 启用Giscus评论系统，设置仓库为 `he0xwhale/ai_blog`，仓库ID为 `R_kgDOOy_oHw`，类别为 `Announcements`，类别ID为 `DIC_kwDOOy_oH84CrUlf`。
  3. 设置语言为 `zh-CN`，主题为浅色和深色模式。

## 5. 个性化元素
- **Volantis配置**：使用了自定义的logo图片 `/images/logo.png`，作者头像 `/images/website/logo.png`。
- **Butterfly配置**：需要在Butterfly中设置类似的个性化图片。
- **移植步骤**：
  1. 将Volantis中使用的图片文件复制到Butterfly主题的相应目录。
  2. 在Butterfly配置文件中设置logo和头像图片路径。
