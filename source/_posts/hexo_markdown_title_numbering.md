---
title: "Hexo 博客中 Markdown 标题序号的添加与规范实践"
date: 2025-06-10 17:00:00
categories: 博客搭建
tags:
  - Hexo
  - Markdown
  - 标题序号
  - 博客规范
---
## 引言

在写博客时，Markdown 标题序号经常会出现缺失或混乱的问题，尤其是在多人编辑或长期维护的博客项目中。标题结构跳级也常导致 Hexo 渲染页面时出现错乱，比如标题被误识为列表，页面结构紊乱。

本文聚焦两个核心问题：

- 如何统一给 Markdown 标题添加序号，以及如何清理已有的错误序号；
- 如何检测并规范标题等级跳级，避免 Hexo 渲染异常。

---

## Part 1：统一添加 / 删除标题序号

### 1.1 使用 VS Code 插件自动添加序号

推荐使用 VS Code 插件 **Markdown All in One** 来自动给 Markdown 标题添加序号。

- 安装插件后，使用命令面板（Ctrl+Shift+P）执行：`Add/Update Section Numbers`
- 该命令会遍历文档所有标题，自动添加类似如下的编号：

```markdown
## 1. 项目初始化
### 1.1 安装依赖
```

**注意：**

- 目前该插件只能生成阿拉伯数字格式的序号；
- 它不会自动检测并删除已有的编号，重复执行可能导致序号重复。

### 1.2 删除已有标题序号（使用 Replace Rules）

为了避免编号重复，建议先清理已有的编号。

- 使用 VS Code 插件 **Replace Rules** 可以批量替换文本，自动清理标题中的旧编号。
- 在工作区根目录下创建 `.vscode/replace-rules.json` 文件，写入如下规则：

```json
[
  {
    "find": "^(#{2,6})\s+(\d+(\.\d+)*\s+)(.*)",
    "replace": "$1 $4",
    "flags": "gm"
  }
]
```

- 使用命令面板执行 `Replace Rules: Run Rule`，即可一键删除二级到六级标题中多余的数字编号。

---

## Part 2：检测并规范标题跳级结构

### 2.1 标题跳级问题简介

Markdown 标题跳级指的是标题等级没有按顺序递增，常见示例：

```markdown
## 项目初始化
#### 安装依赖
## 功能介绍
```

这里，二级标题下直接出现了四级标题，导致 Hexo 渲染时后续的二级标题 `功能介绍` 被误认为是有序列表，造成排版和目录显示混乱。

### 2.2 使用 Markdownlint 检查标题结构

通过 VS Code 插件 **markdownlint** 可以实时检测标题跳级问题。

- 安装插件后，在项目根目录创建 `.markdownlint.json`，启用标题层级规则：

```json
{
    "default": false,
    "MD001": true
}
```

- 规则说明：
  - `MD001` 要求标题级别必须顺序递增，不允许跳级；

这样可以帮助你及时发现跳级错误，保证 Markdown 结构规范，避免 Hexo 渲染异常。

---

## 总结与推荐工作流

### 推荐工作流程

1. **检测标题跳级**：使用 `markdownlint` 规范标题等级顺序，保证结构正确；
2. **清理旧序号**：用 `Replace Rules` 批量删除已有数字编号，避免重复；
3. **添加新序号**：用 `Markdown All in One` 插件统一生成阿拉伯数字格式序号；
4. **最终校验并发布**。

### 关键工具清单

- **Markdown All in One**：自动添加标题序号
- **Replace Rules**：清理旧的标题编号
- **markdownlint**：检测标题跳级和其他规范问题

---

## 附录

### `.markdownlint.json` 示例配置

```json
{
    "default": false,
    "MD001": true
}
```

### `replace-rules.json` 示例

```json
[
  {
    "find": "^(#{2,6})\s+(\d+(\.\d+)*\s+)(.*)",
    "replace": "$1 $4",
    "flags": "gm"
  }
]
```
