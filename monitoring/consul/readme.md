# consul的配置
https://github.com/starsliao/ConsulManager/blob/main/docs/Consul%E9%83%A8%E7%BD%B2%E8%AF%B4%E6%98%8E.md

# ~~token获取~~
```
consul acl bootstrap | grep SecretID
```
> 参照configmap内容，此命令不需要了，而且执行也不会生成新的token

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

- 同样在statefulset模式部署下，若删除consul底层数据，然后用consul snapshot的方式恢复，则会保留kv数据，缺丢失service数据，虽然能在consul中看到service内容，但是consulmanager里却不显示
```
# 备份
consul snapshot save --http-addr=https://consul.github.icu --token=xxxxx --stale consul_backup.snap

# 查看备份信息
consul snapshot inspect consul_backup.snap

# 恢复
consul snapshot restore --http-addr=https://consl.github.icu --token=xxxxx consul_backup.snap
```
