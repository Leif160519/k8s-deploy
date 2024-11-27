## 用法
```
kubectl create configmap -n monitoring snmp-config --from-file=snmp_synology.yml
kubectl apply -f 1.deployment-synology.yaml
kubectl apply -f 2.service.yaml
```

## 参考
### Dashboard
- [Synology NAS Details][1]
- [Synology NAS Details Dashboard for Prometheus][2]
- [Synology NAS Overview Dashboard for Prometheus][3]

### 教程
- [群晖 NAS 监控][4]
- [snmp_synology_nas.yml][5]

## prometheus配置：
```
- job_name: synology
  metrics_path: /snmp
  static_configs:
    - labels:
        module: synology_common,synology_interface
        auth: synology_v3
        brand: Synology
      targets:
        - 192.168.31.250 # 群辉的ip地址
```

## 说明
- 若想常规部署snmp-exporter则
```
kubectl apply -f 1.deployment.yaml
```

[1]: https://grafana.com/grafana/dashboards/14284-synology-nas-details/
[2]: https://grafana.com/grafana/dashboards/22265-synology-nas-details-dashboard-for-prometheus/
[3]: https://grafana.com/grafana/dashboards/22266-synology-nas-overview-dashboard-for-prometheus/
[4]: https://github.com/robotneo/networkdevice-monitor/tree/main/generator/synology
[5]: https://github.com/robotneo/networkdevice-monitor/blob/main/generator/synology/snmp/snmp_synology_nas.yml
