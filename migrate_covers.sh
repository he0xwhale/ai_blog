#!/bin/bash

# 定义文章目录
POSTS_DIR="./source/_posts"

echo "开始迁移文章封面图：headimg 替换为 cover..."

# 遍历所有Markdown文件
find "$POSTS_DIR" -name "*.md" | while read -r file; do
    echo "处理文件: $file"
    # 使用 sed 替换 headimg 为 cover
    # -i 选项用于直接修改文件
    # s/pattern/replacement/g 用于全局替换
    sed -i 's/^headimg:/cover:/g' "$file"
done

echo "迁移完成。"
