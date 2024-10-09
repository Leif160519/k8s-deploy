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

> kv备份的是站点管理，自建主机管理，自建mysql管理和自建redis管理的数据

## 备份恢复所有数据
```
# 备份
consul snapshot save --http-addr=https://consul.github.icu --token=xxxxx --stale consul_backup.snap

# 查看备份信息
consul snapshot inspect consul_backup.snap

# 恢复
consul snapshot restore --http-addr=https://consul.github.icu --token=xxxxx consul_backup.snap
```

> snapshot备份的全部数据，包含kv

## 关于tensuns的备份和恢复操作

### 备份
- 1.使用consul命令备份kv数据
- 2.在tensuns界面上导出站点数据，xlsx格式

### 恢复
- 1.停止tensuns服务，kubernetes部署的话可以设置副本数为0
- 2.停止consul服务，删除consul数据目录
- 3.重启consul服务，让其重新生成consul数据
- 4.使用consul命令恢复kv数据
- 5.启动tensuns服务，kubernetes部署的话可以设置副本数为1
- 6.登录tensuns，修改云厂商的access id和access key，点击同步看是否报错
- 7.同步云厂商资源无报错之后再tensuns界面上导入之前备份的xlsx站点数据
- 8.验证
