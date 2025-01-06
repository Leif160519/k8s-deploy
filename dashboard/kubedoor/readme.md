## 前提
确保安装了helm
```
 wget -c https://get.helm.sh/helm-v3.16.4-linux-amd64.tar.gz
 tar -zxvf helm-v3.16.4-linux-amd64.tar.gz
 rsync -avP linux-amd64/helm /usr/local/bin
 chmod +x /usr/local/bin/helm
```

## 通过ingress域名访问
```
kubectl apply -f ingress.yaml
```

## 如果想添加其他service监控
- 1.修改configmap
```
kubectl edit configmap -n kubedoor kubedoor-config
```

> 修改`NAMESPACE_LIST`内容

- 2.重启kubedoor-api和kubedoor-webhook
```
kubectl rollout restart deployment -n kubedoor kubedoor-api kubedoor-webhook
```

## 访问内置grafana
浏览器访问`http://<server_ip>:xxxxx/grafana`,如果是ingress域名访问，也同样在域名后面加上`/grafana`路由

> 如想用外置grafana查看监控，可导入`kubedoor-grafana.json`看板

## 参考
- [CassInfra/KubeDoor][1]

[1]: https://github.com/CassInfra/KubeDoor?tab=readme-ov-file
