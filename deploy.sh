#!/bin/bash

set -e # 出错即停

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m' # No Color

print_step() {
    echo -e "${CYAN}==> $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# === Hexo 编译与部署 ===
print_step "Cleaning Hexo cache and public folder..."
hexo clean

print_step "Generating static files..."
hexo generate

print_step "Deploying to GitHub Pages..."
hexo deploy

print_success "Hexo deploy completed."

# === 子模块处理 ===
print_step "Checking for changes in submodule: themes/butterfly..."
cd themes/butterfly

if [ -n "$(git status --porcelain)" ]; then
    print_warning "Changes detected in 'themes/butterfly'."
    read -p "📝 Enter commit message for butterfly submodule: " butterfly_msg

    git add .
    git commit -m "$butterfly_msg"
    git push origin HEAD

    print_success "Submodule 'butterfly' committed and pushed."
else
    print_success "No changes in submodule 'butterfly'."
fi

cd ../..

# === 主仓库处理 ===
read -p "📝 Enter commit message for main repository: " commit_msg

print_step "Committing changes in main repository..."
git add themes/butterfly # 子模块引用更新
git add .                # 其他文件变更
git commit -m "$commit_msg"
git push origin main

print_success "Main repository committed and pushed."

echo -e "${GREEN}🎉 All done!${NC}"
