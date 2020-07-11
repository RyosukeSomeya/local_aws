# local_aws
ローカル開発用疑似AWS環境

## 要件
1. dockerネットワーク内に各AWSサービスのコンテナを構築する。
2. 開発PC内からlocalhost:ポート番号でアクセスできる。
3. 初期サービスはRedis（Elasthcache想定)と、S3
4. 原則amazon公式のdocker imageを使用する
5. 起動時に各種設定が完了し、すぐに使える状態を用意する
6. 起動はワンライナーで終了する(初回起動用と、通常起動用は分ける)

## メリット
1. 費用を気にせず、AWSサービスとの連携を実験できる。
2. 様々なAWSサービスのイメージを使うことで、全てではないがlocal環境にすぐに再現、追加できる。
3. 壊しても怒られない
4. ローカルマシンへの依存を極力なくすことで、初期セットアップやPC引っ越し時に、開発環境構築を効率化できる
5. PC本体に色々インストールすることないので、不必要にPC内を汚さないで済む

## 構成図
<img src="https://user-images.githubusercontent.com/40926770/87226322-f38c6d80-c3cd-11ea-8163-ee373c848b8f.jpg" width="100%" />
ローカルマシンのlocalhost内に、docker環境を構築。
RedisCluster用のコンテナとローカルAWS（localstack）用の2つのコンテナを用意。

いずれのコンテナにも**localhost:ポート番号**でアクセス可能

## 使い方
1. docker-composeを起動する
```
cd local_aws
# local_awsディレクトリに移動

./start.sh
# start.sh実行
# => local awsコンテナとRedisClusterコンテナが立ち上がる
```
2. 確認
```
# Redisのノードへredis-cliで接続
redis-cli -h localhost -p 7000

# ブラウザでlocalstackのコンソールへアクセス
http://localhost:9000/
```

3. awsサービスへのcliからの操作
S3
```
# バケット作成
aws --endpoint-url=http://localhost:4572 s3 mb s3://test-bucket

# バケット確認
aws --endpoint-url=http://localhost:4572 s3 ls

# ファイルを配置
touch sample.txt
aws --endpoint-url=http://localhost:4572 s3 cp sample.txt s3://test-bucket/

# バケット内を確認
aws --endpoint-url=http://localhost:4572 s3 ls s3://test-bucket
```
DynamoDB
```
# テーブル作成
aws --endpoint-url=http://localhost:4569 dynamodb create-table --table-name Sample --attribute-definitions AttributeName=Artist,AttributeType=S         AttributeName=SongTitle,AttributeType=S --key-schema AttributeName=Artist,KeyType=HASH AttributeName=SongTitle,KeyType=RANGE --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1
```
※localhost:9000でブラウザでコンソールにアクセスすると、バケットやテーブルが作成されているのを確認できる。

※データの永続化はdocker-compose.ymlの環境変数DATA_DIRを設定することで可能。(現状は未設定)
<img width="100%" alt="スクリーンショット 2020-07-11 23 50 39" src="https://user-images.githubusercontent.com/40926770/87226827-6b0fcc00-c3d1-11ea-8b39-81de4e3d1065.png">
