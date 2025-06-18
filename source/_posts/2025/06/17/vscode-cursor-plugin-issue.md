---
title: 用 Cursor 开发 VSCode 插件时遇到的版本兼容性问题排查实录
date: 2025-06-17 22:13:00 +08:00
updated: 2025-06-17 22:13:00 +08:00
categories:
  - 开发实战
tags:
  - VSCode
  - Cursor
  - 插件开发
  - 踩坑记录
headimg: /images/cover/vscode-cursor-plugin-issue.jpg
description: 记录一次用 Cursor 开发 VSCode 插件时遇到的环境兼容性问题、排查过程与解决方案，帮助开发者少走弯路。
---

# VSCode 插件在 Cursor 不能用？一次环境兼容性大坑的排查与解决

最近在开发 VSCode 插件时，遇到了一个非常隐蔽但又很有代表性的大坑：插件在官方 VSCode 客户端中一切正常，但在 Cursor 编辑器中死活激活不了，命令也不显示。

这篇文章记录我的排查过程、最终的解决办法，以及一些经验教训，希望能帮到遇到类似问题的你。

## 问题描述

我写了一个 VSCode 插件，在官方 VSCode 客户端里可以正常激活和使用，命令也能正常显示。
但当我切换到 Cursor 编辑器，发现插件根本没有被激活，命令也找不到。

我反复检查代码、配置，依赖也都装了，编译也没报错，就是不行！

## 排查过程

### 1. 常规排查

- 重新安装依赖（`pnpm install`）
- 重新编译（`pnpm run compile`）
- 检查 `package.json` 配置
- 查看输出面板和调试控制台

结果都没有发现明显问题。

### 2. 环境对比（真实心路）

其实在排查过程中，我并没有第一时间注意到 VSCode 和 Cursor 的底层版本差异。
一开始只是觉得它们界面很像，理所当然地以为插件兼容性不会有大问题。

直到我在向 ChatGPT 提问、查找资料时，AI 给出的参考链接里，有一位开发者在论坛帖子中提到了 Cursor 的 VSCode 版本和 package.json 里声明的版本不一致，我才恍然大悟！

### 3. 灵感来源

这个帖子真的救了我一命：[How to debug a VS Code extension using CursorAI]()

他们的解决办法是：
把 `package.json` 里的 vscode 版本降级到 Cursor 支持的版本，比如 `^1.93.0`，然后重新装依赖、重新编译，插件就能用了！

## 解决办法

1. 修改 package.json：
```json
{
    "engines": {
        "vscode": "^1.93.0"
    }
}
```

2. 同步修改 `@types/vscode` 依赖版本为 `^1.93.0`

3. 重新安装依赖：
```bash
pnpm install
```

4. 重新编译：
```bash
pnpm run compile
```

重启 Cursor，插件终于能正常激活了！

## 经验与建议

- 环境兼容性问题很隐蔽，尤其是 VSCode 插件开发，别只盯着代码，环境和依赖版本也很关键！
- 遇到问题多去官方论坛、社区搜一搜，有时候一句话就能救你一天。
- 提问时尽量描述清楚环境差异和具体表现，这样更容易获得有用的答案。
- 很多时候，我们并不是靠自己一步步推理出来的，而是通过社区、AI、搜索引擎等外部信息，才发现了问题的本质。





## 参考链接

- [How to debug a VS Code extension using CursorAI]()

如果你也遇到类似问题，欢迎在评论区留言交流！

**希望这篇文章能帮你少走弯路！**

*如需进一步交流，欢迎关注我的频道/博客，后续会持续分享更多开发实战经验！*