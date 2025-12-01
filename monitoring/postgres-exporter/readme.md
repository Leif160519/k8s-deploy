## 由于不同的postgresql实例可能会涉及不同的用户名和库，所以prometheus中关于监控多个pgsql实例的写法，做了调整(参照snmp相关的配置，url需要通过标签进行拼接)
```
- job_name: postgres
  static_configs:
    - labels:
        auth_module: foo1
      targets:
        - postgresql.foo1.svc:5432
    - labels:
        auth_module: foo2
      targets:
        - postgresql.foo2.svc:5432
  metrics_path: /probe
  relabel_configs:
    - source_labels: [__address__]
      target_label: __param_target
    - source_labels: [__param_target]
      target_label: instance
    - target_label: __address__
      replacement: postgres-exporter:9187
    - source_labels: [auth_module]
      target_label: __param_auth_module
```

## 参考
- [dashboard-9628][1]
- [prometheus-community/postgres_exporter][2]

[1]: https://grafana.com/grafana/dashboards/9628-postgresql-database/
[2]: https://github.com/prometheus-community/postgres_exporter
