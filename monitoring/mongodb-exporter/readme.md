## 注意
- 如果是监控mongodb集群，且mongodb集群是k8s三节点部署，采用两个svc的情况下，mongodb地址需要写成如下形式(一定要指定参数replicaSet,后面的值可以通过远程mongodb节点，执行rs.status()查询):
```
mongodb://root:123456@mongodb-0.mongodb.database.svc.cluster.local:27017,mongodb-1.mongodb.database.svc.cluster.local:27017,mongodb-2.mongodb.database.svc.cluster.local:27017/?replicaSet=cluster
```

## prometheus中关于监控多个mongodb实例的写法(参照snmp相关的配置，url需要通过标签进行拼接)
```
- job_name: mongodb
  static_configs:
    - targets:
        - mongodb-0.mongodb.database.svc:27017
        - mongodb-1.mongodb.database.svc:27017
        - mongodb-2.mongodb.database.svc:27017
  relabel_configs:
    - source_labels: [__address__]
      target_label: __param_target
    - source_labels: [__param_target]
      target_label: instance
    - target_label: __address__
      replacement: mongodb-exporter:9216
```

## 参考
- [dashboard-16490][1]
- [percona/mongodb_exporter][2]

[1]: https://grafana.com/grafana/dashboards/16490-opstree-mongodb-dashboard/
[2]: https://github.com/percona/mongodb_exporter
