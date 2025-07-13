# DevContainer Ubuntu 開発環境

Ubuntu 24.10ベースの開発コンテナプロジェクトです。MySQL 8.0データベースサービスを含む包括的な開発環境を提供します。

## 概要

このプロジェクトは以下の機能を提供する統合開発環境です：

- Ubuntu 24.10ベースイメージ
- MySQL 8.0データベースサービス
- Python 3 (pip付き)
- Node.js LTS (nvm経由)
- PHP + Composer
- 各種開発ツールとCLIユーティリティ

## アーキテクチャ

### コンテナ構成

Docker Composeで2つのサービスを管理：

1. **devcontainer**: Ubuntu 24.10を実行するメイン開発コンテナ
   - 親ディレクトリを `/workspace` にマウント
   - Docker-in-Docker操作のためのDockerソケットアクセス
   - 特権モードで実行

2. **ubuntu_mysql**: MySQL 8.0データベースコンテナ
   - ポート3306でアクセス可能
   - デフォルトデータベース: `laravel`
   - デフォルトユーザー: `laravel` (パスワード: `laravel`)
   - rootパスワード: `root`

### ディレクトリ構造

```
/workspace/devcontainer_ubuntu/
├── .devcontainer/       # DevContainer設定
│   └── logs/           # DevContainerセットアップログ
├── docker/              # Docker設定ファイル
│   ├── Dockerfile      # Ubuntu 24.10ベースイメージセットアップ
│   ├── motd.sh        # 起動メッセージスクリプト
│   ├── mysql/         # MySQL設定
│   │   └── conf.d/    # MySQL カスタム設定
│   └── logs/          # Dockerサービスログ
│       └── mysql/     # MySQLログ
├── docker-compose.yml   # コンテナオーケストレーション
├── postCreateCommand.sh # 初期セットアップスクリプト (一度だけ実行)
├── postStartCommand.sh  # 起動スクリプト (開始時毎回実行)
└── README.md           # このファイル
```

## セットアップ

### 前提条件

- Docker
- Docker Compose

### 起動手順

1. プロジェクトディレクトリに移動
```bash
cd /workspace/devcontainer_ubuntu
```

2. コンテナを起動
```bash
docker-compose up -d
```

3. 開発コンテナにアクセス
```bash
docker exec -it ubuntu bash
```

## 基本的なコマンド

### コンテナ管理

```bash
# コンテナを起動
docker-compose up -d

# コンテナログを表示
docker-compose logs -f

# 開発コンテナシェルにアクセス
docker exec -it ubuntu bash

# コンテナを停止
docker-compose down
```

### データベースアクセス

```bash
# 開発コンテナからMySQLに接続
mysql -h ubuntu_mysql -u laravel -plaravel laravel

# rootとして接続
mysql -h ubuntu_mysql -u root -proot
```

## ログの場所

- DevContainerセットアップログ: `/workspace/devcontainer_ubuntu/.devcontainer/logs/setup.log`
- MySQLログ: `/workspace/devcontainer_ubuntu/docker/logs/mysql/`

## 重要な注意事項

1. **パッケージ管理**: Dockerfileには必須パッケージのみ含まれています。開発ツールはpostCreateCommand.shで安装され、ベースイメージを最小限で柔軟に保ちます。

2. **ボリュームマウント**: docker-compose.ymlで以下をマッピング：
   - `./.devcontainer/logs:/var/log/devcontainer` (devcontainerログ用)
   - `./docker/logs/mysql:/var/log/mysql` (MySQLログ用)

3. **MySQL設定**: カスタムMySQL設定は `./docker/mysql/conf.d/custom.cnf` からマウント

4. **ユーザーコンテキスト**: コンテナは `ubuntu` (UID 1000) でsudo権限付きで実行

5. **開発環境**:
   - Node.js LTSはpostCreateCommand.shでnvm経由でインストール
   - PHP、Composer、その他ツールはコンテナ初期化時にインストール
   - Pythonパッケージはユーザー毎にインストール

6. **CLIツール**: Claude Code CLIを含む各種開発CLIツールが利用可能な場合インストール

## 開発ワークフロー

1. **初期セットアップ**: `docker-compose up -d` でコンテナを起動
2. **開発**: コンテナにアクセスして `/workspace` で作業
3. **データベース**: データベース関連開発でMySQLサービスを使用
4. **ログ**: 初期化中に問題が発生した場合、セットアップログを確認

## トラブルシューティング

### 一般的な問題

- **コンテナが起動しない**: `docker-compose logs` でログを確認
- **MySQL接続エラー**: コンテナが完全に起動するまで待機
- **権限の問題**: コンテナは特権モードで実行されるため、sudo権限が利用可能

### ログの確認

```bash
# DevContainerセットアップログ
cat .devcontainer/logs/setup.log

# MySQLログ
ls docker/logs/mysql/
```

## ライセンス

このプロジェクトは開発環境用のテンプレートです。