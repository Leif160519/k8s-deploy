# 准备工作
- 1.将ssl证书重命名为tls.crt和tls.key
- 2.创建secrets： `kubectl -n cattle-system create secret tls tls-rancher-ingress --cert=tls.crt  --key=tls.key`

# 参考
https://ranchermanager.docs.rancher.com/zh/v2.6/getting-started/installation-and-upgrade/resources/add-tls-secrets
