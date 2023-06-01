初始账户：
admin/Kuboard123

https://kuboard.cn/install/v3/install-in-k8s.html#%E5%AE%89%E8%A3%85-2

# 版本升级
https://kuboard.cn/install/v3-upgrade.html#%E5%A6%82%E6%9E%9C%E4%BB%A5-docker-run-%E8%BF%90%E8%A1%8C-kuboard

# 如果是双master节点，部署hostpath时会起不来，清参考
https://github.com/eip-work/kuboard-press/issues/365

- 1.编辑配置文件
···
kubectl edit cm kuboard-v3-config -n kuboard
···

- 2.搜索此配置项,将此配置项替换
```
KUBOARD_SERVER_NODE_PORT: '30080'
```

- 3.将上面的内容替换，根据自己情况写自己k8s节点的任意IP(我写的是vip)
```
KUBOARD_ENDPOINT: 'http://192.168.31.110:30080'
```

- 4.删除之前的 pod 让它自己拉起来 看日志后发现正常了
```
kubectl delete pod kuboard-v3-76996c957f-zd8g5 -n kuboard
```

- 5.查看日志
```
kubectl logs -f kuboard-v3-76996c957f-l5wgh -n kuboard
```

- 6.账号密码
```
admin
Kuboard123
```

# 若是双master节点，kube-etcd会启动两个，而且有一个daemonset会反复重启
```
kubectl edit daemonsets -n kuboard kuboard-etcd
```

在container平级部分添加以下内容，指定kuboard-etcd运行在某一台master节点上
```
nodeName: k8s-master-01
```
注意： 确保指定的节点名称存在，否则pod会一直处于pending状态
