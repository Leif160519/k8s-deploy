## 配置
```
- job_name: ping
  metrics_path: /probe
  scrape_interval: 60s
  relabel_configs:
    - target_label: __param_target
      source_labels: [__address__]
    - target_label: __address__
      replacement: fping-exporter:9605
    - target_label: instance
      source_labels: [__param_target]
  static_configs:
    - targets:
        - 114.114.114.114
        - 8.8.8.8
```

## 参考：https://github.com/schweikert/fping-exporter
