## 前提
确保安装了helm
```
 wget -c https://get.helm.sh/helm-v3.16.4-linux-amd64.tar.gz
 tar -zxvf helm-v3.16.4-linux-amd64.tar.gz
 rsync -avP linux-amd64/helm /usr/local/bin
 chmod +x /usr/local/bin/helm
```

## 部署
cd kubedoor
### 【master端安装】
# 编辑values-master.yaml文件，请仔细阅读注释，根据描述修改配置内容。
# try
helm upgrade -i kubedoor . --namespace kubedoor --create-namespace --values values-master.yaml --dry-run --debug
# install
helm upgrade -i kubedoor . --namespace kubedoor --create-namespace --values values-master.yaml
### 【agent端安装】
# 编辑values-agent.yaml文件，请仔细阅读注释，根据描述修改配置内容。
helm upgrade -i kubedoor-agent . --namespace kubedoor --create-namespace --values values-agent.yaml --set tsdb.external_labels_value=xxxxxxxx

## 通过ingress域名访问

```
kubectl apply -f ingress.yaml
```

## 访问内置grafana
浏览器访问`http://<server_ip>:xxxxx/grafana`,如果是ingress域名访问，也同样在域名后面加上`/grafana`路由

## 修改定时任务产生的job数量
```
kubectl edit cronjobs.batch -n kubedoor kubedoor-collect

找到successfulJobsHistoryLimit，修改为其他数字，设置为0代表不保留
```

## 不想用vmalert和重复部署alertmanager
- 1.删除vmalert和alertmanager相关组件
```
kubectl delete deployment -n kubedoor alertmanager vmalert
kubectl delete configmap -n kubedoor alertmanager-config vmalert-config
kubectl delete svc -n kubedoor alertmanager vmalert
```

- 2.在monitoring里的alertmanager新增kubedoor-alarm的webhook接口
```
webhook_configs:
  - url: 'http://kubedoor-alarm.kubedoor.svc/clickhouse'
     send_resolved: true
```

## 注意
- 1.若clickhouse在某次意外后重建，但是无法起来，可能是日志表占用太大空间导致的，这时候可以把deployment里的健康检查去掉，重新启动即可
然后连接clickhouse，执行查询语句:
```
SELECT
    database,
    table,
    active,
    count(*) AS parts,
    formatReadableSize(sum(bytes_on_disk)) AS size,
    sum(bytes_on_disk) AS size_bytes
FROM system.parts
GROUP BY database, table, active
ORDER BY size_bytes DESC;
```
效果：
```
clickhouse-client -h clickhouse.kubedoor.svc -u default --password di88fg2k
ClickHouse client version 22.10.2.11 (official build).
Connecting to clickhouse.kubedoor.svc:9000 as user default.
Connected to ClickHouse server version 25.3.3 revision 54476.

ClickHouse client version is older than ClickHouse server. It may lack support for new features.

chdb_kubedoor :) SELECT
:-]     database,
:-]     table,
:-]     active,
:-]     count(*) AS parts,
:-]     formatReadableSize(sum(bytes_on_disk)) AS size,
:-]     sum(bytes_on_disk) AS size_bytes
:-] FROM system.parts
:-] GROUP BY database, table, active
:-] ORDER BY size_bytes DESC;

SELECT
    database,
    table,
    active,
    count(*) AS parts,
    formatReadableSize(sum(bytes_on_disk)) AS size,
    sum(bytes_on_disk) AS size_bytes
FROM system.parts
GROUP BY
    database,
    table,
    active
ORDER BY size_bytes DESC

Query id: 13109408-473c-4bda-b518-5d8d38f08447

┌─database─┬─table───────────────────┬─active─┬─parts─┬─size───────┬──size_bytes─┐
│ system   │ trace_log               │      1 │    27 │ 30.58 GiB  │ 32836124877 │
│ system   │ text_log                │      1 │    40 │ 4.25 GiB   │  4565367921 │
│ system   │ metric_log              │      1 │   736 │ 2.00 GiB   │  2142261397 │
│ system   │ asynchronous_metric_log │      1 │    17 │ 676.61 MiB │   709472566 │
│ system   │ latency_log             │      1 │    17 │ 103.51 MiB │   108542546 │
│ system   │ part_log                │      1 │     6 │ 5.55 MiB   │     5819804 │
│ system   │ trace_log               │      0 │     7 │ 4.15 MiB   │     4347722 │
│ system   │ asynchronous_metric_log │      0 │     7 │ 1.91 MiB   │     2007814 │
│ system   │ error_log               │      1 │    10 │ 1.23 MiB   │     1292547 │
│ system   │ part_log                │      0 │     2 │ 1.12 MiB   │     1175408 │
│ system   │ processors_profile_log  │      0 │     3 │ 954.22 KiB │      977122 │
│ system   │ processors_profile_log  │      1 │     7 │ 887.46 KiB │      908763 │
│ system   │ query_metric_log        │      1 │     6 │ 873.63 KiB │      894595 │
│ system   │ error_log               │      0 │     9 │ 858.91 KiB │      879524 │
│ system   │ text_log                │      0 │     6 │ 674.28 KiB │      690465 │
│ kubedoor │ k8s_pod_alert_days      │      1 │   143 │ 296.12 KiB │      303230 │
│ kubedoor │ k8s_resources           │      1 │     5 │ 20.07 KiB  │       20550 │
│ system   │ latency_log             │      0 │     3 │ 5.25 KiB   │        5381 │
│ kubedoor │ k8s_res_control         │      1 │     1 │ 3.51 KiB   │        3599 │
│ kubedoor │ k8s_agent_status        │      1 │     1 │ 898.00 B   │         898 │
└──────────┴─────────────────────────┴────────┴───────┴────────────┴─────────────┘

20 rows in set. Elapsed: 0.050 sec. Processed 1.05 thousand rows, 47.08 KB (20.91 thousand rows/s., 934.94 KB/s.)
```

查看到active为1的两个日志表，一个是trace_log还有一个是text_log都占据了很大的空间，可以清空掉，清空命令如下：
```
TRUNCATE TABLE system.trace_log;
TRUNCATE TABLE system.text_log;
```

效果：
```
chdb_kubedoor :) TRUNCATE TABLE system.trace_log;

TRUNCATE TABLE system.trace_log

Query id: c5195350-d188-443a-95e1-17c850e7cfd6

Ok.

0 rows in set. Elapsed: 76.713 sec.

chdb_kubedoor :) TRUNCATE TABLE system.text_log;

TRUNCATE TABLE system.text_log

Query id: 099d6046-aa70-464b-88dc-51b91d766a96

Ok.

0 rows in set. Elapsed: 23.988 sec.
```

然后设置将trace_log的数据只保留1天，sql如下：
```
SET max_table_size_to_drop = 0;
TRUNCATE TABLE system.trace_log;
ALTER TABLE system.trace_log MODIFY TTL event_date + INTERVAL 1 DAY;
```

这时候再用之前的select语句查询，空间就立马下来了


## 参考
- [CassInfra/KubeDoor][1]

[1]: https://github.com/CassInfra/KubeDoor?tab=readme-ov-file
