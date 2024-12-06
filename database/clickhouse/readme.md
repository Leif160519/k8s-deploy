## 生成密码(返回的第一行是明文，第二行是密文)

```
PASSWORD=$(base64 < /dev/urandom | head -c8); echo "$PASSWORD"; echo -n "$PASSWORD" | sha256sum | tr -d '-'

ggnCNbwr
dd1aec5a29cc9c38e1081066765edd5dc8a121a8bc000dd525b44d32443cb7cb
```

> 明文用于clickhouse-client登录，密文用于修改39行的内容

## grafana集成
grafana安装clickhouse插件命令:
```
grafana-cli plugins install grafana-clickhouse-datasource
```
安装成功后重启grafana
```
kubectl rollout restart deployment -n monitoring grafana
```


## 暴露内部监控指标
`config.xml`中新增以下配置
```
<prometheus>
    <endpoint>/metrics</endpoint>
    <port>9363</port>
    <metrics>true</metrics>
    <events>true</events>
    <asynchronous_metrics>true</asynchronous_metrics>
    <status_info>true</status_info>
</prometheus>
```

将9363端口暴露出来，之后在prometheus中添加clickhouse的job即可

## 添加看板
- [14192-clickhouse][]

[1]: https://grafana.com/grafana/dashboards/14192-clickhouse/
