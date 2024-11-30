## 前置条件
mongodb集群如果使用moosefs文件存储，则需要设置文件夹属性`mfsseteattr -f nodatacache <mongodb-pvc-dir> -r`,否则若遇到异常关机的情况，会导致mongodb部分文件无法从缓存写入磁盘导致文件损坏无法读取，集群信息丢失等问题！

## 参数说明
- 1.configmap中`replSetName`指的是集群的id名称，可自定义
- 2.configmap中`keyFile`指的是集群内部加密通信的文件路径，非集群模式(单节点)可不指定,若集群模式未指定keyfile，后期想加keyfile，则需要重新加入集群，有数据丢失风险

## 准备工作
```
openssl rand -base64 753 > mongodb-keyfile
chmod 600 mongodb-keyfile
kubectl create secret generic mongodb-keyfile --from-file=mongodb-keyfile -n database

或者直接用：
kubectl apply -f 1.secret.yaml
```

## 使用方法
```
kubectl -f 2.configmap.yaml -f 3.service.yaml -f 4.statefulset.yaml
```

## 修改mongodb镜像版本到5.0以上之后运行报错(image: mongo/5.0.3)
```
    State:          Waiting
      Reason:       CrashLoopBackOff
    Last State:     Terminated
      Reason:       Error
      Exit Code:    132
      Started:      Tue, 29 Aug 2023 13:55:36 +0800
      Finished:     Tue, 29 Aug 2023 13:55:36 +0800
    Ready:          False
```

退出码132，意味着cpu指令不支持，`mongo:5.0.3`需要AVX指令集支持，若是用类似J1900这种cpu，本身不支持AVX指令集的，就无法启动，需要降低mongo的版本，可以使用`mongo:4.4.9`，该版本不需要AVX指令集，参考：[Docker安装mongodb，退出代码132][1]

> 如何判断cpu支不支持AVX指令集:`lscpu | grep -i avx`

## 副本集集群搭建方法(保证mongodb几个节点网络互通)
- 1.选择即将作为主节点的pod，登录
```
kubectl exec -it mongodb-0 -n database -- bash
```

- 2.登录mongodb
```
mongo --host 127.0.0.1
```

- 3.定义集群信息
```
config = {
     '_id': 'cluster',
     'members': [
          {
               '_id': 0,
               'host':'mongodb-0.mongodb.database.svc:27017'
          },
          {
               '_id': 1,
               'host':'mongodb-1.mongodb.database.svc:27017'
          },
          {
               '_id': 2,
               'host':'mongodb-2.mongodb.database.svc:27017'
          }
     ]
}
```
> 0为主节点

- 4.集群初始化
```
#初始化
rs.initiate(config)

#查看状态
rs.status()
```

> 若初始化失败，可以强制初始化`rs.reconfig(config, {force: true})`

## 创建用户并设置角色
因为集群初始化了且创建了用户，所以需要重新登录mongodb集群，如果有mongosh的情况下可以用以下命令进入集群控制台：
```
mongosh mongodb://root:123456@mongodb-0.mongodb.database.svc:27017/
```

```

use admin

#创建root用户
db.createUser(
  {
    user: "root",
    pwd: "123456",
    roles: [
       { role: "root", db: "admin" }]
  }
)
```

## 创建库
```
#可以use一个不存在的库，创建账号
use test_db

#创建用户并指定库
db.createUser(
  {
    user: "test",
    pwd: "test",
    roles: [
       { role: "readWrite", db: "test_db" }]
  }
 )
```

## 集群扩充
### 方法一（集群有数据或无数据情况）
```
#加入从节点
rs.add("mongodb-3.mongodb.database.svc:27017")

#加入仲裁节点(可选操作)
rs.addArb("10.2.112.147:27017")

#查看集群状态
rs.status()
```

> 仲裁节点不存储数据，只存储集群状态信息，针对集群异常情况，切换主节点，仅适用于副本集模式，仲裁节点非集群必须

### 方法二(集群无数据情况)
```
#重新定义集群配置
config = {
     '_id': 'cluster',
     'members': [
          {
               '_id': 0,
               'host':'mongodb-0.mongodb.database.svc:27017'
          },
          {
               '_id': 1,
               'host':'mongodb-1.mongodb.database.svc:27017'
          },
          {
               '_id': 2,
               'host':'mongodb-2.mongodb.database.svc:27017'
          },
          {
               '_id': 3,
               'host':'mongodb-3.mongodb.database.svc:27017'
          }
     ]
}
# 初始化或强制初始化
rs.initiate(config) 或 rs.reconfig(config, {force: true})
```

## 若只想部署一个节点，并且需要运行在指定集群节点上，
在`spec.template.spec`下添加以下内容
```
nodeSelector:
  kubernetes.io/hostname: k8s-node-01
affinity:
  podAntiAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
    - labelSelector:
        matchExpressions:
        - key: app
          operator: In
          values:
          - mongodb
      topologyKey: kubernetes.io/hostname
```

## 注意点
mongodb集群不建议使用单节点部署，首次成功后如果pod被删除或者驱逐，新启动的pod会导致集群失效，提示
```
MongoServerError: node is not in primary or recovering state
```

[1]: https://www.guojiangbo.com/2021/10/04/docker%E5%AE%89%E8%A3%85mongodb%EF%BC%8C%E9%80%80%E5%87%BA%E4%BB%A3%E7%A0%81132/
