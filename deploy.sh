#!/bin/bash

set -e # 出错即停

echo "🧹 Cleaning cache and public folder..."
hexo clean

echo "📦 Generating static files..."
hexo generate

echo "🚀 Deploying to GitHub Pages..."
hexo deploy

echo "✅ Hexo deploy finished."

# 交互式输入 commit message
read -p "📝 Enter commit message for source code: " commit_msg

echo "📁 Committing source code to Git repository..."
git add .
git commit -m "$commit_msg"
git push origin main

echo "🎉 All done!"
