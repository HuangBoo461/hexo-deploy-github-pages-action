# Hexo Deploy GitHub Pages Action

支持同时自动向GitHub与Gitee推送静态文件。

## 开始

可以参考一下配置.

```yml
name: Hexo Deploy GitHub Pages
on:
  push:
    branches:
      - master
jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout
      uses: actions/checkout@master

    - name: Build and Deploy
      uses: HuangBoo461/hexo-deploy-github-pages-action@master
      env:
        # github静态推送时需要用的Access Toekn
        PERSONAL_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        # github静态页面仓库路径.
        PUBLISH_REPOSITORY: theme-keep/site
        # github静态页面仓库分支.
        BRANCH: master
        # gitee静态推送时需要用的Access Toekn
        GITEE_PERSONAL_TOKEN: ${{ secrets.GITEE_TOKEN }}
        # gitee静态页面仓库路径.
        GITEE_PUBLISH_REPOSITORY: luckybo/luckybo.gitee.io
        # gitee静态页面仓库分支.
        GITEE_BRANCH: master
```

如果你想让工作流只在推送事件到特定分支时触发，你可以这样配置: 

```yml
on:
  push:	
    branches:	
      - master
```

## Configuration

工作流程的 `env` 部分**必须**在操作生效之前进行配置。 您可以将这些添加到上面示例中的`env`部分。 必须使用括号语法引用任何“密码”，并将其存储在 GitHub 存储库的“设置/秘密”菜单中。 [您可以在此处了解有关使用 GitHub 操作设置环境变量的更多信息 ](https://help.github.com/en/articles/workflow-syntax-for-github-actions#jobsjob_idstepsenv).

您将在下面找到每个选项的功能说明。

| 键  | 说明 | 类型 | 默认值 | 必填 |
| ------------- | ------------- | ------------- | ------------- | ------------- |
| `PERSONAL_TOKEN`  | 根据存储库权限，您可能需要为操作提供 GitHub 个人访问令牌才能部署。 您可以 [在此处了解有关如何生成一个的更多信息](https://help.github.com/en/articles/creating-a-personal-access-token-for-the-command-line). **This should be stored as a secret**. | `secrets` |  | **是** |
| `PUBLISH_REPOSITORY`  | 操作应部署到的存储库. 例如 `theme-keep/site` | `env` |  | **是** |
| `BRANCH`  | 动作应该部署到的分支. 例如 `master` | `env` | `gh-pages` | **是** |
| `GITEE_PERSONAL_TOKEN` | Gitee 令牌 | `secrets` |  | **是** |
| `GITEE_PUBLISH_REPOSITORY` | Gitee 仓库路径 | `env` |  | **是** |
| `GITEE_BRANCH` | Gitee仓库分支 | `env` |  | **是** |
| `PUBLISH_DIR`  | 操作应部署的文件夹，即hexo生成静态页面目录。例如 `./public` | `env` | `./public` | 否 |

