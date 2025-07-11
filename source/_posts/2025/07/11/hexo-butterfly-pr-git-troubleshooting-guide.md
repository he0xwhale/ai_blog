---
title: Hexo Butterfly 主题 Pull Request 过程中的 Git 实践与常见问题排查
date: 2025-07-11 10:55:00
tags:
  - Hexo
  - Butterfly
  - Git
  - GitHub
  - Pull Request
  - 踩坑记录
  - 问题排查
categories:
  - 博客之旅
  - Git实践
cover: /images/cover/hexo-butterfly-pr-git-troubleshooting-guide.png
---

> 本文是关于向 Hexo Butterfly 主题提交 Pull Request 过程中，我所经历的 Git 实践流程，以及期间遇到的典型问题和解决方案的总结。

---

### **📌 重要注意事项**

本次 Pull Request 的出发点是解决一个关于 Hexo Butterfly 主题分类页和标签页封面图不显示的问题。在 PR 过程中，我得到了主题作者的反馈，这修正了我对 `themes/butterfly/_config.yml` 中 `category_img` 和 `tag_img` 配置项的理解。

**核心 Bug 根源的修正理解：**
*   **最初的误解**：我曾认为 `category_img` 和 `tag_img` 是用于设置分类页 `/categories/` 和标签页 `/tags/` 主页的封面图。
*   **正确的理解**：`category_img` 和 `tag_img` 实际上是为**文章**（posts）在分类/标签归档页面中提供一个**备用**的封面图。而分类页 `/categories/` 和标签页 `/tags/` 的主封面图，应该在它们各自的 Markdown 文件（例如 `source/categories/index.md` 和 `source/tags/index.md`）的 Front-matter 中通过 `top_img` 属性来配置。

**尽管如此，本文后续提及的 Git 操作和问题排查经验仍然是通用的，且本文中涉及到的 Pug 模板代码修正（已在 PR 中提交）也完善了主题的逻辑，使其能更灵活地处理这些页面类型。**

关于这个 Bug 问题的详细调试过程、代码修正细节以及对 `tag_img` 和 `category_img` 作用的更详细解释，请参阅我的另一篇文章：[《一次因缓存引发的“灵异事件”：Hexo Butterfly 主题封面图调试全记录》](/2025/07/09/hexo-butterfly-cover-image-debug-story/)。

---

## 引言

参与开源项目贡献是提升技术能力、回馈社区的绝佳方式。然而，对于初次接触或不熟悉 Git/GitHub 工作流的朋友来说，其中的一些操作细节可能会成为不小的挑战。本文将以我向 Hexo Butterfly 主题提交 Pull Request 的亲身经历为例，分享一套实用的 Git 实践流程，并着重梳理了我在过程中遇到的常见问题及其排查与解决之道。

## PR 背景与核心问题简述

本次 Pull Request 的背景是解决 Hexo Butterfly 主题中一个关于分类页和标签页封面图显示的问题。尽管后来发现对 `tag_img` 和 `category_img` 的配置用途存在误解，但对 Pug 模板的修正（已提交 PR）仍然是有效的，它优化了主题在处理这些页面类型时的逻辑。

**关于 Bug 详情、代码修正和关键解决方案（Hexo 缓存问题）**：请参阅 [《一次因缓存引发的“灵异事件”：Hexo Butterfly 主题封面图调试全记录》](/2025/07/09/hexo-butterfly-cover-image-debug-story/)。

## Hexo Butterfly 主题 Pull Request 实践流程

以下是我向 Hexo Butterfly 主题提交 Pull Request 的具体操作步骤，这是一个推荐的、能够保持提交纯净的流程。

### 1. Fork 官方仓库并克隆到本地

首先，在 GitHub 上将官方的 `jerryc127/hexo-theme-butterfly` 仓库 Fork 到您自己的账户下（例如 `he0xwhale/hexo-theme-butterfly`）。然后，将您 Fork 后的仓库克隆到本地。

```bash
# 克隆您 Fork 后的仓库到本地
git clone https://github.com/he0xwhale/hexo-theme-butterfly.git
cd hexo-theme-butterfly # 进入主题目录
```

### 2. 创建并切换到新的修复分支

为了保持主分支的整洁，并方便管理不同的功能或修复，我们应该为每次贡献创建一个新的分支。

```bash
# 基于当前分支（通常是 dev 或 master）创建并切换到新分支
git checkout -b fix-page-cover
```

### 3. 进行代码修改

在新的分支上进行您需要的代码修改。对于本次 PR，关键的修改位于 [`themes/butterfly/layout/includes/header/index.pug`](themes/butterfly/layout/includes/header/index.pug)。

### 4. 精确暂存并提交代码

完成代码修改后，我们需要将修改添加到 Git 的暂存区，并创建一个提交。**关键在于只添加您希望贡献的文件，避免混入个人配置。**

```bash
# 只将对 index.pug 的修改添加到暂存区
git add layout/includes/header/index.pug

# 提交修改，附上清晰的提交信息
git commit -m "Fix: Display cover images for categories and tags pages"
```

### 5. 推送分支到您的 Fork 仓库

现在，将包含您修改的新分支推送到您在 GitHub 上的 Fork 仓库。

```bash
# 推送分支到自己的远程仓库
git push origin fix-page-cover
```

### 6. 在 GitHub 上创建 Pull Request

当您成功推送分支后，访问您 Fork 仓库的 GitHub 页面，或者直接使用 `git push` 输出中提供的链接，创建 Pull Request。

*   **填写 PR 信息**：提供清晰的标题和详细的描述，解释您解决了什么问题，为什么重要，如何复现，以及您的解决方案。

## Pull Request 过程中遇到的典型问题及排查

在上述流程中，我遇到了一些常见的 Git 问题，以下是我当时的排查过程和最终解决方案。

### 问题场景 1：`git commit` 失败 ("无文件要提交，干净的工作区")

**问题描述**：在执行 `git add` 之后尝试 `git commit`，但 Git 提示“无文件要提交，干净的工作区”。这表明尽管我执行了 `git add`，但实际上并没有任何修改被暂存。

**排查与解决**：这通常发生在您在 `git add` 之前，工作区已经被其他操作（例如 `git stash`）清空了修改。
*   **解决方案**：首先确认工作区是否有您需要的修改（`git status`）。如果修改被 `stash` 了，需要先 `git stash pop` 恢复。然后重新 `git add` 目标文件，再 `git commit`。

### 问题场景 2：`git push` 权限被拒绝 (403 Forbidden)

**问题描述**：在尝试将本地分支推送到远程仓库时，Git 提示 `remote: Permission denied` 和 `403 Forbidden` 错误。

**排查与解决**：这是因为本地仓库的 `origin` 远程地址指向了您没有推送权限的仓库（例如官方仓库）。
*   **解决方案**：将本地 `origin` 远程地址修改为自己 Fork 后的仓库地址。
    ```bash
    # 在 themes/butterfly 目录下执行
    git remote set-url origin https://github.com/he0xwhale/hexo-theme-butterfly.git
    ```
    （请将 `he0xwhale` 替换为您的 GitHub 用户名）

### 问题场景 3：`git push` 提示“仓库未找到” (`Repository not found`)

**问题描述**：在更新了 `origin` 地址并尝试 `git push` 后，Git 提示 `fatal: 仓库 'https://github.com/he0xwhale/hexo-theme-butterfly.git/' 未找到`。

**排查与解决**：这表明您在 `git remote set-url` 中指定的 URL 对应的仓库在 GitHub 上不存在。这通常意味着您还没有成功地 Fork 官方仓库。
*   **解决方案**：请访问官方 Butterfly 主题的 GitHub 页面 ([https://github.com/jerryc127/hexo-theme-butterfly](https://github.com/jerryc127/hexo-theme-butterfly))，然后点击页面右上角的 **"Fork"** 按钮，在您的 GitHub 账户下创建一个副本。

## 总结

向开源项目贡献代码是一个充满挑战但也极具成就感的过程。通过解决实际问题，并遵循标准的 Git/GitHub 流程，我们不仅提升了自身的技术能力，也为社区贡献了一份力量。希望本文总结的这些常见问题和解决方案，能为您在开源贡献的道路上提供一些帮助。