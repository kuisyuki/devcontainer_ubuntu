#!/bin/bash

# MySQL ヘルスチェックスクリプト
# Docker Composeでヘルスチェックに使用

set -e

# MySQL接続テスト
mysql -h ubuntu_mysql -u laravel -plaravel -e "SELECT 1;" > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "MySQL is healthy"
    exit 0
else
    echo "MySQL is not responding"
    exit 1
fi