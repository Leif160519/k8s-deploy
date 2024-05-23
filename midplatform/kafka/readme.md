## 注意
安装kafka集群之前请先安装zookeeper集群

## 集群验证
```
#任意两台服务器登录kafka，一个发送，一个监听
kubectl  exec -it kafka-x /bin/bash
```

a.建topic：
```
# kafka-topics.sh --create --zookeeper zookeeper-1.zookeeper-hs:2181 --replication-factor 1 --partitions 1 --topic test
```

b.发送信息：
```
kafka-console-producer.sh --broker-list kafka-1.kafka-hs:9092 --topic test
你好
```

c.接收信息：
```
kafka-console-consumer.sh --bootstrap-server kafka-2.kafka-hs:9092 --topic test --from-beginning
```
