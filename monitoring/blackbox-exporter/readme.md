## 使用方法
```
kubectl apply -f 1.configmap.yaml
kubectl apply -f 2.service-clusterip.yaml
kubectl apply -f 3.service-clusterip.yaml
kubectl apply -f 4.deployment.yaml
```

## 更新配置
```
kubectl edit configmap blackbox-config -n monitoring
```
> 更新后configmap-reload容器会自动重载blackbox配置,延迟大概在2分钟以内

## 参考
https://github.com/jimmidyson/configmap-reload
