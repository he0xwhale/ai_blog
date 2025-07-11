---
title: "从 Hexo 模板创建新博客并独立管理 Volantis 子模块的完整过程"
date: 2025-06-19 14:52:18
categories:
  - 博客之旅
  - 基础搭建
tags:
  - Hexo
  - Git
  - Volantis
  - Git Submodule
cover: /images/cover/hexo_submodule_split_blog.png
---

在 Hexo 博客搭建中，很多用户会选择将主题如 Volantis 作为子模块管理以便于后续更新。然而，如果你想以现有的博客为模板创建新的博客，并保留主题改动，同时又不希望多个项目之间相互干扰，合理管理 Git 子模块就显得非常重要。

本文记录了一个完整的实践过程，包含遇到的问题、原因分析和最终的解决方法。

## 场景说明

- 已有博客项目：`ai_blog`，使用 fork 的 Volantis 主题作为 Git 子模块，且 `_config.yml` 中做了大量定制修改；
- 目标：创建一个新博客 `tech_blog`，以 `ai_blog` 为基础模板，但希望主题配置独立；
- 遇到的问题包括：子模块复用导致冲突、分支不同步、远程混乱、推送失败等。

---

## 一、从模板创建新项目

```bash
# 克隆 ai_blog，包括子模块
git clone --recursive https://github.com/yourname/ai_blog.git tech_blog
cd tech_blog

# 删除旧 git 记录，准备建立新仓库
rm -rf .git
git init

# 重新添加远程并提交
git remote add origin https://github.com/yourname/tech_blog.git
git add .
git commit -m "初始化 tech_blog"
git push -u origin main
```

---

## 二、Volantis 主题子模块独立化  

### 原问题

多个项目共享同一个 fork 的主题仓库，如果任意一个项目修改了 `_config.yml` 并 `push`，会影响其他项目。

### 解决方案：为新博客单独创建 volantis-tech 仓库

1. 首先在github上创建新的空白仓库：volantis-tech

2. 再执行下面的命令
   
        ```bash
   
   # 克隆 volantis 源仓库
   
    git clone --bare https://github.com/yourname/volantis.git volantis-bare
    cd volantis-bare
   
   # 推送为新仓库
   
    git push --mirror https://github.com/yourname/volantis-tech.git
   
   # 清理
   
    cd ..
    rm -rf volantis-bare
   
   ```
   
   ```

---

## 三、彻底移除旧子模块并添加新主题

```bash
# 移除旧子模块引用
git submodule deinit -f themes/volantis
git rm -f themes/volantis
rm -rf .git/modules/themes/volantis
rm -rf themes/volantis
rm -f .gitmodules

# 添加新的 volantis-tech 作为子模块
git submodule add https://github.com/yourname/volantis-tech.git themes/volantis
git submodule update --init --recursive
```

---

## 四、关于 `_config.yml` 修改后未生效的问题

> 修改了 `themes/volantis/_config.yml`，但 GitHub 页面没有变化？

这是因为 Volantis 是子模块，其更改需要进入子模块内部手动提交和推送：

```bash
cd themes/volantis
git checkout -b custom-fontawesome
git add _config.yml
git commit -m "修改配置"
git push --set-upstream origin custom-fontawesome
```

然后回到主项目：

```bash
cd ../..
git add themes/volantis
git commit -m "更新子模块引用"
git push
```

---

## 五、解决 `git push` 报错问题

例如：

```
fatal: 当前分支 main 没有对应的上游分支。
```

解决方式：

```bash
git push --set-upstream origin main
```

---

## 六、其他注意事项

- `.git/modules/` 是 Git 存放子模块缓存数据的地方，必须清除干净；
- 使用多个项目共用子模块时，应考虑使用不同分支，或完全复制主题；
- 如果不能再 fork 自己的仓库，可以用 `git clone --bare` + `git push --mirror` 方案手动创建副本。

---

## 总结

通过本次实践，我们完整演示了如何从已有 Hexo 项目中派生一个新项目，并妥善管理子模块以避免多个项目间的冲突。推荐在多个博客中使用 fork + 分支方式隔离配置，确保互不干扰。
