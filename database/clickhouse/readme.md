## 生成密码(返回的第一行是明文，第二行是密文)

```
PASSWORD=$(base64 < /dev/urandom | head -c8); echo "$PASSWORD"; echo -n "$PASSWORD" | sha256sum | tr -d '-'

ggnCNbwr
dd1aec5a29cc9c38e1081066765edd5dc8a121a8bc000dd525b44d32443cb7cb
```

> 明文用于clickhouse-client登录，密文用于修改39行的内容

## grafana集成
grafana安装clickhouse插件命令:
```
grafana-cli plugins install grafana-clickhouse-datasource
```
安装成功后重启grafana
```
kubectl rollout restart deployment -n monitoring grafana
```


## 暴露内部监控指标
`config.xml`中新增以下配置
```
<prometheus>
    <endpoint>/metrics</endpoint>
    <port>9363</port>
    <metrics>true</metrics>
    <events>true</events>
    <asynchronous_metrics>true</asynchronous_metrics>
    <status_info>true</status_info>
</prometheus>
```

将9363端口暴露出来，之后在prometheus中添加clickhouse的job即可

## 添加看板
- [14192-clickhouse][1]

## 注意
- clickhouse体积太大导致重启后服务就绪很慢，或者单纯想减少体积，可按照如下操作清空日志表
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
ch_accesslog :) SELECT
    database,
    table,
    active,
    count(*) AS parts,
    formatReadableSize(sum(bytes_on_disk)) AS size,
    sum(bytes_on_disk) AS size_bytes
FROM system.parts
GROUP BY database, table, active
ORDER BY size_bytes DESC

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

Query id: f6f1eb8b-027f-4d1e-81bb-49dcee51f1af

┌─database──┬─table───────────────────┬─active─┬─parts─┬─size───────┬─size_bytes─┐
│ system    │ metric_log              │      1 │    61 │ 5.25 GiB   │ 5636043929 │
│ system    │ trace_log               │      1 │    38 │ 4.25 GiB   │ 4566351840 │
│ system    │ asynchronous_metric_log │      1 │    64 │ 3.67 GiB   │ 3944435661 │
│ system    │ query_log               │      1 │    49 │ 175.68 MiB │  184217847 │
│ system    │ trace_log               │      0 │   128 │ 119.70 MiB │  125515023 │
│ system    │ part_log                │      1 │    44 │ 102.99 MiB │  107994923 │
│ system    │ metric_log              │      0 │    70 │ 25.08 MiB  │   26299253 │
│ system    │ query_log               │      0 │    32 │ 16.52 MiB  │   17325731 │
│ system    │ asynchronous_metric_log │      0 │    89 │ 8.56 MiB   │    8973091 │
│ nginxlogs │ nginx_access            │      1 │    47 │ 8.19 MiB   │    8588687 │
│ system    │ part_log                │      0 │    30 │ 5.09 MiB   │    5333473 │
│ nginxlogs │ nginx_access            │      0 │    42 │ 1.19 MiB   │    1246410 │
└───────────┴─────────────────────────┴────────┴───────┴────────────┴────────────┘

12 rows in set. Elapsed: 0.004 sec.
```

查看到active为1的几个日志表，一个是metric_log，trace_log，asynchronous_metric_log等都占据了很大的空间，可以清空掉，清空命令如下：
```
truncate table system.metric_log;
truncate table system.trace_log;
truncate table system.asynchronous_metric_log;
```
然后设置将这些log的数据只保留1天，sql如下：
```
SET max_table_size_to_drop = 0;
ALTER TABLE system.metric_log MODIFY TTL event_date + INTERVAL 1 DAY;
ALTER TABLE system.trace_log MODIFY TTL event_date + INTERVAL 1 DAY;
ALTER TABLE system.asynchronous_metric_log MODIFY TTL event_date + INTERVAL 1 DAY;
```

> 其他日志表以此类推执行sql即可

[1]: https://grafana.com/grafana/dashboards/14192-clickhouse/
