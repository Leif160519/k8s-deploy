## 安装步骤
### 1.安装caretta流量统计工具
```
# 1.安装helm
# 2.helm添加安装源
helm repo add groundcover https://helm.groundcover.com/

# 3.helm更新源
helm repo update

# 4.安装caretta
helm install caretta --namespace caretta --create-namespace groundcover/caretta
```

### 2.安装radar
```
# 1.下载
curl -LO https://github.com/skyhook-io/radar/releases/download/v1.0.1/radar_v1.0.1_linux_amd64.tar.gz

# 2.解压
tar -zxvf radar_v1.0.1_linux_amd64.tar.gz

# 3.复制到指定目录
rsync -avP kubectl-radar /usr/local/bin/radar
```

### 3.启动radar服务
> 由于caretta-vm并没有对外暴露端口，直接改svc也不行，所以我们直接用endpoint的地址即可，也就是pod的ip+端口号，只要确保radar部署在kubernetes节点上即可

```
# 1.获取caretta-vm的endpoint地址
kubectl get ep -n caretta
caretta-vm        172.16.59.250:8428   12d

# 2.将vm记录下来并生成radar服务文件
vim /lib/systemd/system/kube-radar.service

[Unit]
Description=kube-radar
After=network-online.target

[Service]
Type=simple
Environment="GOMAXPROCS=8"
User=root
Group=root
ExecReload=/bin/kill -HUP $MAINPID
ExecStart=/usr/local/bin/radar \
    --kubeconfig=/root/.kube/config \
    --port=9280 \
    --timeline-storage=sqlite \
    --timeline-db=/root/.radar/timeline.db \
    --history-limit=10000 \
    --namespace="" \
    --no-browser \
    --prometheus-url=http://172.16.59.250:8428

ProtectSystem=full
Restart=always

[Install]
WantedBy=multi-user.targe

# 3.启动radar服务并设置开机自启动
systemctl start kube-radar
systemctl enable kube-radar
```

## 参考
- [groundcover-com/caretta][1]
- [skyhook-io/radar][2]

[1]: https://github.com/groundcover-com/caretta
[2]: https://github.com/skyhook-io/radar
