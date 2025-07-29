## prometheus配置
```
- job_name: ntp
  metrics_path: /metrics
  relabel_configs:
    - source_labels: [__address__]
      target_label: __param_target
    - source_labels: [__param_target]
      target_label: instance
    - target_label: __address__
      replacement: ntp-exporter:9559
    - target_label: __param_protocol
      replacement: "4"
    - target_label: __param_duration
      replacement: "10s"
    - target_label: __param_high_drift
      replacement: "100ms"
  static_configs:
    - targets:
        - 192.168.31.181
```

## 参考
- [ntp_exporter][1]

[1]: https://github.com/sapcc/ntp_exporter/
