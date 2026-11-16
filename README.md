# idea-template

单页想法 / 项目主页模板。基于 [Academic Project Page Template](https://github.com/eliahuhorwitz/Academic-project-page-template)（源自 [Nerfies](https://nerfies.github.io)，CC BY-SA 4.0），做了这些改动：

- 去掉了示例视频、图片和 PDF，换成轻量的占位图
- 新增 KaTeX 公式（行内用 `$...$`，独立公式用 `$$...$$`）、TL;DR、Method、结果表格、Discussion
- 删除了 More Works 下拉菜单、Adobe PDF SDK 和 slider

## 新建一个想法页

```bash
/data/ideas/idea-template/new-idea.sh <repo-name> "Page Title"
```

脚本会创建公开仓库 `SagShang/<repo-name>`，克隆到 `/data/ideas/<repo-name>`，填好标题和网址，并开启 GitHub Pages。
网址：`https://sagshang.github.io/<repo-name>/`

## 写内容

- 文字：编辑 `index.html`，每个区块都有中文注释
- 图片：放进 `static/images/`；视频（MP4，建议小于 20MB）放进 `static/videos/`
- 本地预览：`python3 -m http.server 8000`，然后打开 http://localhost:8000
- 发布：`git add -A && git commit -m "..." && git push`，大约 1 分钟后生效
