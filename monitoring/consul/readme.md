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
consul kv export --http-addr=https://consul.github.icu -token=9ce1358e-da13-4b7b-b79e-7f7b16408d47 > consul_kv_backup.json
# 恢复
consul kv import --http-addr=https://consul.github.icu -token=9ce1358e-da13-4b7b-b79e-7f7b16408d47 @consul_kv_backup.json
```

> kv备份的是云厂商数据

## 备份恢复所有数据
```
# 备份
consul snapshot save --http-addr=https://consul.github.icu --token=9ce1358e-da13-4b7b-b79e-7f7b16408d47 --stale consul_backup.snap

# 查看备份信息
consul snapshot inspect consul_backup.snap

# 恢复
consul snapshot restore --http-addr=https://consul.github.icu --token=9ce1358e-da13-4b7b-b79e-7f7b16408d47 consul_backup.snap
```

> snapshot备份的全部数据，包含kv和service数据

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
- 6.登录tensuns，先找到云厂商配置进行资源同步，同步有问题的话重新修改云厂商的access id和access key，点击同步看是否报错
- 7.同步云厂商资源无报错之后再tensuns界面上导入之前备份的xlsx站点数据
- 8.验证

## 故障排查
因为数据存储故障，导致consul起不来
```
==> Starting Consul agent...
               Version: '1.16.0'
            Build Date: '2023-06-26 20:07:11 +0000 UTC'
               Node ID: '0cd95b70-6b7a-d742-8f8f-063c83932091'
             Node name: 'consul-0'
            Datacenter: 'dc1' (Segment: '<all>')
                Server: true (Bootstrap: true)
           Client Addr: [0.0.0.0] (HTTP: 8500, HTTPS: -1, gRPC: -1, gRPC-TLS: -1, DNS: -1)
          Cluster Addr: 172.16.38.15 (LAN: 8301, WAN: -1)
     Gossip Encryption: false
      Auto-Encrypt-TLS: false
           ACL Enabled: true
     Reporting Enabled: false
    ACL Default Policy: deny
             HTTPS TLS: Verify Incoming: false, Verify Outgoing: false, Min Version: TLSv1_2
              gRPC TLS: Verify Incoming: false, Min Version: TLSv1_2
      Internal RPC TLS: Verify Incoming: false, Verify Outgoing: false (Verify Hostname: false), Min Version: TLSv1_2

==> Log data will now stream in as it occurs:

2026-03-12T20:19:41.593+0800 [ERROR] agent: startup error: error="error reading server metadata: unexpected end of JSON input"
2026-03-12T20:19:51.594+0800 [ERROR] agent: startup error: error="error reading server metadata: unexpected end of JSON input"
2026-03-12T20:20:01.594+0800 [ERROR] agent: startup error: error="error reading server metadata: unexpected end of JSON input"
2026-03-12T20:20:11.594+0800 [ERROR] agent: startup error: error="error reading server metadata: unexpected end of JSON input"
2026-03-12T20:20:21.595+0800 [ERROR] agent: startup error: error="error reading server metadata: unexpected end of JSON input"
2026-03-12T20:20:31.652+0800 [ERROR] agent: startup error: error="error reading server metadata: unexpected end of JSON input"
2026-03-12T20:20:41.654+0800 [ERROR] agent: Error starting agent: error="error reading server metadata: unexpected end of JSON input"
```

> 解决办法
- 1.进入consul数据目录
- 2.查看server_metadata.json文件是否为空或者损坏
- 3.若文件为空或者损坏，删除这个文件
- 4.重启consul服务，让其自动重建
- 5.检查consul服务是否正常
