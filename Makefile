# DevContainer管理用Makefile

.PHONY: help build up down restart logs status clean reset

# デフォルトターゲット
help:
	@echo "利用可能なコマンド:"
	@echo "  make build    - コンテナをビルド"
	@echo "  make up       - コンテナを起動"
	@echo "  make down     - コンテナを停止"
	@echo "  make restart  - コンテナを再起動"
	@echo "  make logs     - ログを表示"
	@echo "  make status   - コンテナの状態を表示"
	@echo "  make clean    - 停止コンテナとイメージを削除"
	@echo "  make reset    - 完全リセット（データベースも削除）"
	@echo "  make shell    - 開発コンテナにアクセス"
	@echo "  make mysql    - MySQLに接続"

# コンテナをビルド
build:
	docker-compose build

# コンテナを起動
up:
	docker-compose up -d

# コンテナを停止
down:
	docker-compose down

# コンテナを再起動
restart: down up

# ログを表示
logs:
	docker-compose logs -f

# コンテナの状態を表示
status:
	docker-compose ps

# 開発コンテナにアクセス
shell:
	docker exec -it ubuntu bash

# MySQLに接続
mysql:
	docker exec -it ubuntu mysql -h ubuntu_mysql -u laravel -plaravel laravel

# 停止コンテナとイメージを削除
clean:
	docker-compose down
	docker system prune -f

# 完全リセット（データベースも削除）
reset:
	docker-compose down -v
	docker system prune -f --volumes