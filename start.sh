#!/bin/bash

# キャッシュを使わず新しいイメージをビルド
docker-compose build --no-cache

# docker-composeをバックグラウンド起動
docker-compose up -d

# コンテナにアタッチし、Redis Cluster作成
docker exec -it redis_cluster bash -c "/bin/bash cluster.sh"


