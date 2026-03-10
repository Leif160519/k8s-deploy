## 说明
- vmware_exporter 利用 vmware 官方维护的 pyvmomi 的 SDK 得到指标数据，但是该项目已不维护,项目地址:[pryorda/vmware_exporter][1]

## prometheus中配置
```
- job_name: vmware
  metrics_path: '/metrics'
  static_configs:
    - targets:
      - 'vmware-exporter:9272'
  relabel_configs:
    - source_labels: [__address__]
      target_label: __param_target
    - source_labels: [__param_target]
      target_label: instance
    - target_label: __address__
      replacement: vmware-exporter:9272
```

[1]: https://github.com/pryorda/vmware_exporter
