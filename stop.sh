#!/bin/bash
# コンテナ停止＆削除
docker-compose down

# 未使用のコンテナとイメージを削除
yes | docker container prune
yes | docker image prune
