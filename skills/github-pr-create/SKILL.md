---
name: github-pr-create
description: Create a pull request with the gh CLI when the current repository is hosted on GitHub. Use this when a user asks to open, draft, or submit a pull request from the terminal for the current branch.
---

# GitHub Pull Request

この skill は、現在の Git リポジトリのリモートが GitHub 上にある場合に、`gh` を使ってプルリクエストを作成するための手順を提供する。

## 使う条件

- ユーザがプルリクエストの作成を求めている。
- 作業対象が Git リポジトリである。
- `origin` などの対象リモートが GitHub でホストされている。

GitLab の場合はこの skill を使わず、`gitlab-mr-create` を使う。

## 基本方針

- まず現在のブランチ、変更状態、リモート URL を確認する。
- GitHub ホストかを判定してから `gh` を使う。
- 既に PR がある可能性も確認する。
- タイトルと本文は、ユーザ指定があればそれを優先する。未指定なら `--fill` を優先する。
- ブランチが未 push なら、PR 作成前に `git push -u origin <branch>` を行う。

## 手順

1. Git リポジトリか確認する。
2. 現在のブランチ名を確認する。
3. `git remote get-url origin` などでリモート URL を確認する。
4. リモートが GitHub でない場合は、この skill の対象外として中断し、適切な skill に切り替える。
5. `gh --version` と `gh auth status` で CLI と認証状態を確認する。
6. 必要なら `git push -u origin <branch>` で対象ブランチを push する。
7. 既存 PR がないか `gh pr view --json number,url --head <branch>` などで確認する。
8. 新規作成する場合は、次の優先順で `gh pr create` を実行する。

## 推奨コマンド

タイトルと本文がユーザから明示されている場合:

```bash
gh pr create --base <base-branch> --head <current-branch> --title "<title>" --body "<body>"
```

タイトルと本文が未指定の場合:

```bash
gh pr create --base <base-branch> --head <current-branch> --fill
```

Draft が求められている場合:

```bash
gh pr create --base <base-branch> --head <current-branch> --fill --draft
```

## 実務上の注意

- `origin` が GitHub 以外で、別リモートが GitHub の場合は、どのリモートを使うかを明示して進める。
- ベースブランチが不明なら、既定ブランチを確認して使う。必要なら `gh repo view --json defaultBranchRef` を使う。
- 変更内容に未整理の差分が多い場合、PR 作成前にユーザへそのまま進めるかを確認してよい。
- 既存 PR が見つかった場合は重複作成せず、その URL を報告する。
- `gh auth status` が失敗した場合は、認証が必要であることを簡潔に伝える。

## 禁止事項

- GitHub 以外のホストに対して `gh pr create` を実行しない。
- ユーザの指定なしに PR のタイトルや本文を断定的に捏造しない。
- 既存 PR の有無を確認せずに重複作成しない。
