## 准备工作
### 0.准备外置mysql，初始化数据库
```
mysql -h mysql.github.icu -u root -p < initsql/a-n9e.sql
```

### 1.修改`etc-nightingale`中`config.toml`中关于mysql和redis的配置

### 2.创建configmap
```
kubectl create configmap -n monitoring nightingale-config \
    --from-file etc-nightingale/config.toml \
    --from-file etc-nightingale/metrics.yaml \
    --from-file etc-nightingale/script/notify.bak.py \
    --from-file etc-nightingale/script/notify_feishu.py \
    --from-file etc-nightingale/script/notify.py \
    --from-file etc-nightingale/script/rule_converter.py
```

## 部署
```
kubectl apply -f .
```

## 用户名密码
默认用户是 root，密码是 root.2020。

## 参考
[安装部署详解][1]

[1]: https://flashcat.cloud/docs/content/flashcat-monitor/nightingale-v6/install/intro/
