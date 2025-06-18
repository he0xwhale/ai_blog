#!/bin/bash

# 使用方法： ./hexo-new-post.sh "文章标题"
TITLE="$1"

if [ -z "$TITLE" ]; then
    echo "请输入文章标题"
    exit 1
fi

# 获取当前日期
YEAR=$(date +"%Y")
MONTH=$(date +"%m")
DAY=$(date +"%d")

# 组合生成路径
DIR="source/_posts/$YEAR/$MONTH/$DAY"
FILENAME="$(echo "$TITLE" | sed 's/ /-/g').md"

# 创建目录
mkdir -p "$DIR"

# 创建文章
hexo new "$DIR/$FILENAME" "$TITLE"
