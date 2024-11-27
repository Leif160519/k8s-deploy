## 用法
- 1.群辉中开启snmp，勾选`SNMPv3服务`，用户账号填写`monitor`，协议选`SHA`，密码自定义；往下勾选`启用SNMP隐私`，协议选`AES`，密码自定义
- 2.修改snmp_synology.yml头部认证模块
```
auths:
  synology_v3:
    community: public
    security_level: authPriv
    username: monitor
    password: Mrot@2024neo
    auth_protocol: SHA
    priv_protocol: AES
    priv_password: Mrot@2024mei
    version: 3
```

- 3.部署snmp-exporter服务
```
kubectl create configmap -n monitoring snmp-config --from-file=snmp_synology.yml
kubectl apply -f 1.deployment-synology.yaml
kubectl apply -f 2.service.yaml
```

- 4. prometheus配置：
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
  relabel_configs:
  - source_labels: ["__address__"]
    target_label: __param_target
  - source_labels: ["__param_target"]
    target_label: instance
  - target_label: __address__
    replacement: snmp-exporter:9116
  - source_labels: ["module"]
    target_label: __param_module
  - source_labels: ["auth"]
    target_label: __param_auth
```

> 若监控大规模群辉设备，则推荐使用文件形式,将static_configs以及子模块内容替换成：
```
file_sd_configs:
  - files:
    - /etc/prometheus/synology-nas.yml
```

> `/etc/prometheus/synology-nas.yml`内容如下:
```
- labels:
    module: synology_common,synology_interface
    auth: synology_v3
    brand: Synology
  targets:
    - 192.168.31.250
```

## 参考
### Dashboard
- [Synology NAS Details][1]
- [Synology NAS Details Dashboard for Prometheus][2]
- [Synology NAS Overview Dashboard for Prometheus][3]

> `Synology NAS Details Dashboard for Prometheus`实际为`Synology NAS Details`的中文版

### 教程
- [群晖 NAS 监控][4]
- [snmp_synology_nas.yml][5]


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
