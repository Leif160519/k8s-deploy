# consul的配置
https://github.com/starsliao/ConsulManager/blob/main/docs/Consul%E9%83%A8%E7%BD%B2%E8%AF%B4%E6%98%8E.md

# ~~token获取~~
```
consul acl bootstrap | grep SecretID
```
> 参照configmap内容，此命令不需要了，而且执行也不会生成新的token

# 数据备份和恢复
https://www.cnblogs.com/wangguishe/p/15606954.html

## 备份恢复kv数据
```
# 备份
consul kv export --http-addr=https://consul.github.icu -token=xxx > consul_kv_backup.json
# 恢复
consul kv import --http-addr=https://consul.github.icu -token=xxx @consul_kv_backup.json
```

## 备份恢复所有数据
```
# 备份
consul snapshot save --http-addr=https://consul.github.icu --token=xxxxx --stale consul_backup.snap

# 查看备份信息
consul snapshot inspect consul_backup.snap

# 恢复
consul snapshot restore --http-addr=https://consl.github.icu --token=xxxxx consul_backup.snap
```
