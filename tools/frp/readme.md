## 用法
先按照实际情况修改配置文件
### 1.服务端frps部署
```
cd frps/
kubectl create configmap frps-config -n devops --from-file=frps.toml
kubectl apply -f .
```

### 2.客户端frpc部署
先按照实际情况修改配置文件
```
cd frpc/
kubectl create configmap frpc-config -n devops --from-file=frpc.toml
kubectl apply -f
```

## 参考
- [用FRP配置toml文件搭建内网穿透][1]
- [fatedier/frp][2]
- [snowdreamtech/frp][3]

[1]: https://blog.csdn.net/qq_42672770/article/details/137977300
[2]: https://github.com/fatedier/frp
[3]: https://snowdreamtech/frp
