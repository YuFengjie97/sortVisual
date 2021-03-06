#!/usr/bin/env sh

# 发生错误时终止
set -e



# 进入构建文件夹
# cd docs

# 如果你要部署到自定义域名
# echo 'www.example.com' > CNAME

# git init
git checkout gh-pages
git rebase main

# 构建
pnpm run build

git add .
git commit -m 'deploy'
git push -f


# 如果你要部署在 https://<USERNAME>.github.io
# git push -f git@github.com:<USERNAME>/<USERNAME>.github.io.git main

# 如果你要部署在 https://<USERNAME>.github.io/<REPO>
# git push -f git@github.com:<USERNAME>/<REPO>.git main:gh-pages
# git push -f git@github.com:YuFengjie97/sortVisual.git main:gh-pages
cd /