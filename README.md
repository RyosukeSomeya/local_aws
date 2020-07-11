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

## USAGE
redis-cli -h localhost -p 7000
