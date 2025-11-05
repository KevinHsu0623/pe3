#!/usr/bin/env bash
set -o errexit
set -o pipefail

echo "==> Installing Ruby gems"
bundle install --without development test

echo "==> Installing Node dependencies"
yarn install --frozen-lockfile

echo "==> Building frontend assets"
yarn build

echo "==> Precompiling Rails assets"
RAILS_ENV=production bundle exec rails assets:precompile
