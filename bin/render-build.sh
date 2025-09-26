#!/usr/bin/env bash
set -o errexit

bundle install
bin/rails assets:precompile
bin/rails assets:clean

# 免費方案沒有 Pre-deploy，所以先在這裡跑 migrate
bundle exec rails db:migrate
