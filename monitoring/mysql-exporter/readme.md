## 参考
- [如何优雅的使用一个mysqld_exporter监控所有的MySQL实例][1]

[1]: https://github.com/starsliao/TenSunS/blob/main/docs/%E5%A6%82%E4%BD%95%E4%BC%98%E9%9B%85%E7%9A%84%E4%BD%BF%E7%94%A8%E4%B8%80%E4%B8%AAmysqld_exporter%E7%9B%91%E6%8E%A7%E6%89%80%E6%9C%89%E7%9A%84MySQL%E5%AE%9E%E4%BE%8B.md

## 注意
```
ts=2025-07-21T00:18:35.730Z caller=exporter.go:149 level=error msg="Error pinging mysqld" err="Error 1129: Host '10.10.120.84' is blocked because of many connection errors; unblock with 'mysqladmin flush-hosts'" dsn:="exporter:123456@tcp(mysql.jms.svc:3306)/?lock_wait_timeout=2"
```
如果提示连接太频繁导致被mysql主机禁止连接，可以执行以下命令(建议直接去mysql所在机器/Pod/容器上执行)：
```
mysqladmin -h mysql服务地址 -u root -p flush-hosts
``

## 故障排查
- 语法错误
```
ts=2026-03-10T01:11:30.614Z caller=exporter.go:174 level=error msg="Error from scraper" scraper=slave_status err="Error 1064: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'SLAVE STATUS' at line 1" dsn:="exporter:123456@tcp(mysql.zyplayer.svc:3306)/?lock_wait_timeout=2"
```

解决办法：去掉slave状态检测
```
--no-collect.slave_status
```

- 采集中断（表特别多的情况下会出现这种情况）
```
ts=2026-03-10T02:04:10.136Z caller=exporter.go:174 level=error msg="Error from scraper" scraper=info_schema.tables err="context canceled" dsn:="exporter:123456@tcp(10.10.1.230:3306)/?lock_wait_timeout=2"
ts=2026-03-10T02:04:10.136Z caller=exporter.go:174 level=error msg="Error from scraper" scraper=global_variables err="context canceled" dsn:="exporter:123456@tcp(10.10.1.230:3306)/?lock_wait_timeout=2"
```

解决办法：不采集表信息
```
--no-collect.info_schema.tables
```

> 注意：该启动参数与`--collect.info_schema.tables`和`--collect.info_schema.tables.databases=*`参数冲突，不能共存
