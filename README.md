# codex-dotfiles

Codex の設定ファイルを Git で管理し、複数環境で共有しやすくするためのリポジトリです。

このリポジトリでは、`~/.codex` 配下に置きたい共有設定を管理し、セットアップスクリプトでシンボリックリンクを作成します。

## 管理方針

このリポジトリでは、複数環境で共有したい Codex 向けの設定ファイルや補助ファイルを管理します。

共有したい `skills/` などを追加した場合、セットアップスクリプトはそのディレクトリも `~/.codex/skills` にリンクします。

## 管理しないもの

次のようなローカル状態や認証情報は、このリポジトリでは管理しない想定です。

- `~/.codex/auth.json`
- `~/.codex/history.jsonl`
- `~/.codex/sessions/`
- `~/.codex/cache/`
- `~/.codex/log*`
- `~/.codex/*.sqlite*`
- `~/.codex/tmp/`
- `~/.codex/shell_snapshots/`
- `~/.codex/memories/`

## セットアップ

### Linux / macOS

```bash
./setup.sh
```

### Windows

```bat
setup.bat
```

`setup.bat` は `mklink` を使用するため、環境によっては管理者権限のコマンドプロンプト、または Developer Mode が必要です。

## スクリプトの動作

セットアップスクリプトは、`~/.codex` に同名ファイルやディレクトリが既に存在する場合、すぐに上書きせず、次の形式でバックアップを作成してからリンクを張ります。

```text
<元のパス>.backup-YYYYMMDD-HHMMSS
```

標準出力ではなく標準エラーへ進捗とエラーメッセージを出力します。

## 想定運用

1. このリポジトリを任意の場所に clone します。
2. `setup.sh` または `setup.bat` を実行します。
3. `~/.codex/config.toml` と `~/.codex/AGENTS.md` がこのリポジトリ内のファイルを指すようになります。

## 注意

- `config.toml` を完全に共有すると、環境固有の設定も同じになります。
- マシンごとの差分を持ちたい場合は、共有設定とローカル設定を分離する運用を検討してください。
