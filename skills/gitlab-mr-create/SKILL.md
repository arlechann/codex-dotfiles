---
name: gitlab-mr-create
description: Create a merge request with the glab CLI when the current repository is hosted on GitLab. Use this when a user asks to open, draft, or submit a merge request from the terminal for the current branch.
---

# GitLab Merge Request

この skill は、現在の Git リポジトリのリモートが GitLab 上にある場合に、`glab` を使ってマージリクエストを作成するための手順を提供する。

## 使う条件

- ユーザがマージリクエストの作成を求めている。
- 作業対象が Git リポジトリである。
- `origin` などの対象リモートが GitLab でホストされている。

GitHub の場合はこの skill を使わず、`github-pr-create` を使う。

## 基本方針

- まず現在のブランチ、変更状態、リモート URL を確認する。
- GitLab ホストかを判定してから `glab` を使う。
- 既に MR がある可能性も確認する。
- タイトルと本文は、ユーザ指定があればそれを優先する。未指定なら `--fill` を優先する。
- ブランチが未 push なら、MR 作成前に `git push -u origin <branch>` を行う。

## 手順

1. Git リポジトリか確認する。
2. 現在のブランチ名を確認する。
3. `git remote get-url origin` などでリモート URL を確認する。
4. リモートが GitLab でない場合は、この skill の対象外として中断し、適切な skill に切り替える。
5. `glab --version` と `glab auth status` で CLI と認証状態を確認する。
6. 必要なら `git push -u origin <branch>` で対象ブランチを push する。
7. 既存 MR がないか `glab mr view <current-branch>` や `glab mr list --source-branch <current-branch>` で確認する。
8. 新規作成する場合は、次の優先順で `glab mr create` を実行する。

## 推奨コマンド

タイトルと本文がユーザから明示されている場合:

```bash
glab mr create --source-branch <current-branch> --target-branch <base-branch> --title "<title>" --description "<body>"
```

タイトルと本文が未指定の場合:

```bash
glab mr create --source-branch <current-branch> --target-branch <base-branch> --fill
```

Draft が求められている場合:

```bash
glab mr create --source-branch <current-branch> --target-branch <base-branch> --fill --draft
```

## 実務上の注意

- `origin` が GitLab 以外で、別リモートが GitLab の場合は、どのリモートを使うかを明示して進める。
- ベースブランチが不明なら、既定ブランチを確認して使う。必要なら `glab repo view --output json` などで確認する。
- 変更内容に未整理の差分が多い場合、MR 作成前にユーザへそのまま進めるかを確認してよい。
- 既存 MR が見つかった場合は重複作成せず、その URL を報告する。
- `glab auth status` が失敗した場合は、認証が必要であることを簡潔に伝える。

## 禁止事項

- GitLab 以外のホストに対して `glab mr create` を実行しない。
- ユーザの指定なしに MR のタイトルや本文を断定的に捏造しない。
- 既存 MR の有無を確認せずに重複作成しない。
