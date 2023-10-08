# consul的配置
https://github.com/starsliao/ConsulManager/blob/main/docs/Consul%E9%83%A8%E7%BD%B2%E8%AF%B4%E6%98%8E.md

# token获取
consul acl bootstrap|grep SecretID

# 数据备份和恢复
https://www.cnblogs.com/wangguishe/p/15606954.html

# 注意点
- consul由statefulset部署，删除pod之后，在consul 14.5版本下，会丢kv数据，但是不会丢service数据，所以需要事先备份kv数据
```
consul kv export --http-addr=https://consul.github.icu -token=xxx > consul_kv_backup.json
```
删除pod重启后，再重新恢复kv数据即可
```
consul kv import --http-addr=https://consul.github.icu -token=xxx @consul_kv_backup.json
```
