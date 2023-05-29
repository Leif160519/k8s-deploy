# 准备工作
- 1.将ssl证书重命名为tls.crt和tls.key
- 2.创建secrets： `kubectl -n cattle-system create secret tls tls-rancher-ingress --cert=tls.crt  --key=tls.key`
- 3.将ingress的controller的service类型改成`LoadBalancer`，系统会分配一个ip地址
- 4.将rancher域名的dns解析指向上面分配的ip地址
- 5.浏览器直接访问rancher的域名即可

# 重置密码
```
kubectl exec -it -n cattle-system rancher-xxx -- bash
reset-password
```

# 参考
https://ranchermanager.docs.rancher.com/zh/v2.6/getting-started/installation-and-upgrade/resources/add-tls-secrets
