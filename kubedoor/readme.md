## 前提
确保安装了helm
```
 wget -c https://get.helm.sh/helm-v3.16.4-linux-amd64.tar.gz
 tar -zxvf helm-v3.16.4-linux-amd64.tar.gz
 rsync -avP linux-amd64/helm /usr/local/bin
 chmod +x /usr/local/bin/helm
```

## 部署
cd kubedoor
### 【master端安装】
# 编辑values-master.yaml文件，请仔细阅读注释，根据描述修改配置内容。
# try
helm upgrade -i kubedoor . --namespace kubedoor --create-namespace --values values-master.yaml --dry-run --debug
# install
helm upgrade -i kubedoor . --namespace kubedoor --create-namespace --values values-master.yaml
### 【agent端安装】
# 编辑values-agent.yaml文件，请仔细阅读注释，根据描述修改配置内容。
helm upgrade -i kubedoor-agent . --namespace kubedoor --create-namespace --values values-agent.yaml --set tsdb.external_labels_value=xxxxxxxx

## 通过ingress域名访问

```
kubectl apply -f ingress.yaml
```

## 访问内置grafana
浏览器访问`http://<server_ip>:xxxxx/grafana`,如果是ingress域名访问，也同样在域名后面加上`/grafana`路由

## 修改定时任务产生的job数量
```
kubectl edit cronjobs.batch -n kubedoor kubedoor-collect

找到successfulJobsHistoryLimit，修改为其他数字，设置为0代表不保留
```

## 参考
- [CassInfra/KubeDoor][1]

[1]: https://github.com/CassInfra/KubeDoor?tab=readme-ov-file
