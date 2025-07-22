## 操作步骤
- 1.创建secret，将证书挂载到集群中
```
kubectl create secret generic etcd-certs \
    --from-file=ca.pem=/opt/etcd/ssl/ca.pem \
    --from-file=server-key.pem=/opt/etcd/ssl/server-key.pem \
    --from-file=server.pem=/opt/etcd/ssl/server.pem -n monitoring
```

## 以下内容验证没通过
#- 2.创建service和endpoints，通过service代理外部etcd访问
#```
## etcd-service.yaml
#apiVersion: v1
#kind: Service
#metadata:
#  name: etcd-external
#  namespace: monitoring
#spec:
#  ports:
#  - name: metrics
#    port: 2379
#    targetPort: 2379
#  type: ClusterIP
#---
#apiVersion: v1
#kind: Endpoints
#metadata:
#  name: etcd-external
#  namespace: monitoring
#spec:
#  subsets:
#  - addresses:
#    - ip: 10.10.120.81  # 外部 etcd 节点 IP
#      ip: 10.10.120.82
#      ip: 10.10.120.83
#      ip: 10.10.120.84
#      ip: 10.10.120.85
#    ports:
#    - port: 2379
#```

- 3.配置prometheus
```
scrape_configs:
- job_name: 'etcd'
  scheme: https
  tls_config:
    ca_file: /etc/prometheus/secrets/etcd-certs/ca.pem
    cert_file: /etc/prometheus/secrets/etcd-certs/server.pem
    key_file: /etc/prometheus/secrets/etcd-certs/server-key.pem
  static_configs:
  - targets:
    - 192.168.31.81:2379
    - 192.168.31.82:2379
    - 192.168.31.83:2379
    - 192.168.31.84:2379
```

- 4.挂载secret到prometheus
```
# prometheus-deployment.yaml
volumes:
- name: etcd-certs
  secret:
    secretName: etcd-certs
volumeMounts:
- name: etcd-certs
  mountPath: /etc/prometheus/secrets/etcd-certs
  readOnly: true
```
