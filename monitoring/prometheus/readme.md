## 使用方法
```
kubectl apply -f 1.rbac.yaml
kubectl apply -f 2.configmap.yaml
kubectl apply -f 3.pvc.yaml
kubectl apply -f 4.service-clusterip.yaml
kubectl apply -f 5.service-clusterip.yaml
kubectl apply -f 6.deployment.yaml
```

## 更新配置
```
kubectl edit configmap prometheus-config -n monitoring
```
> 更新后configmap-reload容器会自动重载prometheus配置,延迟大概在2分钟以内

## 如果prometheus中配置的victoria地址为域名，非svc写法，则不需要rbac，否则需要创建rbac并且重新创建prometheus pod

## 注意
~~prometheus自己的存储建议选择nfs，不要选择moosefs，因为moosefs写入会有问题，可能与文件系统缓存有关，但没有经过验证~~

~~经过验证，可以使用moosefs作为sc，但是跟jenkins一样，得需要执行`mfsseteattr -f nodatacache <prometheus-pv挂载路径> -r`~~

## 参考
https://github.com/jimmidyson/configmap-reload
