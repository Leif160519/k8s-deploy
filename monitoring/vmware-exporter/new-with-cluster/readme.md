## 说明
- vmware-exporter 利用 vmware 官方维护的 govmomi 的 SDK 得到指标数据，项目地址：[prezhdarov/vmware-exporter][3]

## prometheus配置
```
- job_name: vmware-exporter
  scrape_interval: 20s
  scrape_timeout: 15s
  metrics_path: /metrics
  # metrics_path: /probe
  static_configs:
    - targets:
      - 192.168.31.200
  relabel_configs:
    - source_labels: [__address__]
      target_label: __param_target
    - source_labels: [__param_target]
      target_label: instance
    - target_label: __address__
      replacement: vmware-exporter:9169
```
## 参考
- [robotneo/vmware-exporter][1]
- [虚拟化监控：多 vCenter 不同凭证如何实现VMWare集群的监控告警][2]

[1]: https://github.com/robotneo/vmware-exporter/blob/master/README-zh.md
[2]: https://mp.weixin.qq.com/s/fw9cBAJcWIpraS8ZygMXrA
[3]: https://github.com/prezhdarov/vmware-exporter
