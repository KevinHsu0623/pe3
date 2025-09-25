#!/usr/bin/env bash
set -e

# 等待資料庫（容器啟動時常見）
if [ -n "$DATABASE_URL" ]; then
  echo "Database URL configured."
else
  # 若使用 docker-compose 連本地 db：等待 Postgres
  ./bin/wait-for-it.sh db:5432 -t 60 -- echo "Postgres is up"
fi

# 建立/遷移資料庫
bundle exec rails db:prepare

# 啟動 Puma
exec bundle exec puma -C config/puma.rb
