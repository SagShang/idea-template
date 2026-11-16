#!/usr/bin/env bash
# 用法: ./new-idea.sh <repo-name> ["Page Title"]
# 例子: ./new-idea.sh llm-grasp "LLM-Generated Functional Grasps"
# 从 SagShang/idea-template 创建公开仓库，填好标题和网址，开启 GitHub Pages
# 网址: https://sagshang.github.io/<repo-name>/
set -euo pipefail

OWNER=SagShang
TEMPLATE="$OWNER/idea-template"
BASE_DIR="${IDEAS_DIR:-/data/ideas}"

name="${1:?用法: $0 <repo-name> [\"Page Title\"]}"
title="${2:-$name}"
dir="$BASE_DIR/$name"

if [[ ! "$name" =~ ^[A-Za-z0-9._-]+$ ]]; then
  echo "仓库名只能包含字母、数字、. _ -" >&2; exit 1
fi
if [[ -e "$dir" ]]; then
  echo "$dir 已存在" >&2; exit 1
fi

echo ">> 从模板创建公开仓库 $OWNER/$name"
gh repo create "$OWNER/$name" --public --template "$TEMPLATE" \
  --description "$title"

# 模板复制是异步的，等仓库里有提交再 clone
for i in $(seq 1 30); do
  if gh api "repos/$OWNER/$name/commits?per_page=1" >/dev/null 2>&1; then break; fi
  sleep 2
done
gh repo clone "$OWNER/$name" "$dir"

cd "$dir"
esc_title=$(printf '%s' "$title" | sed -e 's/[\/&|]/\\&/g')
sed -i \
  -e "s|__TITLE__|$esc_title|g" \
  -e "s|__REPO__|$name|g" \
  -e "s|__DATE__|$(date +%Y-%m-%d)|g" \
  -e "s|__BIBYEAR__|$(date +%Y)|g" \
  index.html
rm -f new-idea.sh
printf '# %s\n\nhttps://sagshang.github.io/%s/\n' "$title" "$name" > README.md

git add -A
git commit -q -m "Init idea page: $title"
git push -q origin HEAD

echo ">> 开启 GitHub Pages (main 分支根目录)"
gh api -X POST "repos/$OWNER/$name/pages" \
  -f "source[branch]=main" -f "source[path]=/" >/dev/null

echo
echo "完成。本地目录: $dir"
echo "网址 (首次部署约 1 分钟): https://sagshang.github.io/$name/"
