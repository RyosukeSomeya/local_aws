#!/bin/bash

# 各クラスター用ディレクトリ
redis_dirs=("7000" "7001" "7002" "7003" "7004" "7005")

# 念の為ディレクトリを削除
for i in ${redis_dirs[*]}
do
    if [ -e $i ]; then
    rm -rf $i
    echo "Successfully deleted" $i"dir"
    fi

    if [ $? -ne 0 ]; then
    echo "Fail to delete" $i"dir"
    fi
done

# 各クラスター用ディレクトリ作成
for i in ${redis_dirs[*]}
do
    mkdir $i
    if [ $? -eq 0 ]; then
    echo "Successfully created dir" $i
    fi
done

# それぞれのconfファイルを作成し各ディレクトリに配置
for i in {0..5}
do
port=700${i}
cd $port
cat <<EOF > redis.conf
port $port
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
EOF
cd ..
done

# クラスター作成
# 不要ファイル削除
unnecessary_files=("appendonly.aof" "dump.rdb" "nodes.conf")
for i in ${unnecessary_files[*]}
do
    if [ -e $i ]; then
    rm -r $i
    echo "Successfully deleted " $i
    fi

    if [ $? -ne 0 ]; then
    echo "Fail to delete" $i
    fi
done

# 起動
# 各ディレクトリへ移動し各redisノードを起動
for i in ${redis_dirs[*]}
do
    cd $i
    redis-server redis.conf &
    cd ..
done

# クラスター構築
echo "yes" | redis-cli --cluster create 127.0.0.1:7000 127.0.0.1:7001 127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005 --cluster-replicas 1 | sleep 5 | echo "\n"

if [ -e $i ]; then
    echo "================="
    echo "cluster created!"
    echo "================="
    echo "================="
    echo "cluster status..."
    echo ""
    redis-cli -p 7000 cluster nodes
    echo "================="
else
    echo "#########################"
    echo "failed create cluster... "
    echo "##########################"
fi
