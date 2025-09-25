#!/usr/bin/env bash
# 來源改寫：vishnubob/wait-for-it
HOST="$1"; shift
PORT="$1"; shift
TIMEOUT=60
while ! (echo >/dev/tcp/${HOST}/${PORT}) >/dev/null 2>&1; do
  ((TIMEOUT--))
  if [ $TIMEOUT -le 0 ]; then
    echo "Timeout waiting for ${HOST}:${PORT}"
    exit 1
  fi
  sleep 1
done
exec "$@"
