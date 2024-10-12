# minio 默认账号密码
minioadmin
minioadmin

# 准备工作
## 1.下载velero二进制文件
```
https://github.com/vmware-tanzu/velero/releases/download/v1.12.1/velero-v1.12.1-linux-amd64.tar.gz
tar -zxvf velero-v1.12.1-linux-amd64.tar.gz
cd velero-v1.12.1-linux-amd64
ln -svf velero-v1.12.1-linux-amd64.tar.gz/velero /usr/bin/velero
```

## 2.安装minio
```
kubectl apply -f 1.namespace -f 2.minio.yaml
```

## 3.创建好velero的bucket和用户的secret id和key

## 4.修改`credentials-velero`文件内容的id和key

# 安装velero
```
./install.sh
```

> 这里minio的地址我用的是外部的，避免集群问题导致minio不可用，无法恢复数据

注意：若minio用的是集群外的，请修改`s3url=`后面的minio console的地址,另外确保`credentials-velero`文件的路径根据实际情况进行调整

# 卸载velero
```
velero uninstall 按y确认
```

# 查看velero状态
```
# 看velero的pod是否为Running状态
kubectl get pod -n velero
NAME                      READY   STATUS    RESTARTS   AGE
velero-6c94b8f799-7bc5j   1/1     Running   0          13m

# 看PHASE是否为Available状态，否则会备份失败
velero get backup-locations
NAME      PROVIDER   BUCKET/PREFIX   PHASE       LAST VALIDATED                  ACCESS MODE   DEFAULT
default   aws        velero          Available   2023-05-09 17:06:16 +0800 CST   ReadWrite     true
```

# 备份devops下的jenkins
```
$ velero backup create jenkins --include-namespaces devops --wait
Backup request "jenkins" submitted successfully.
Waiting for backup to complete. You may safely press ctrl-c to stop waiting - your backup will continue in the background.
....
Backup completed with status: PartiallyFailed. You may check for more information using the commands `velero backup describe jenkins` and `velero backup logs jenkins`.
之后去minio的velero bucket中查看是否有数据即可
```

# 更多命令

## 查看备份位置
```
$ velero get backup-locations

NAME      PROVIDER   BUCKET/PREFIX   PHASE       LAST VALIDATED                  ACCESS MODE   DEFAULT
default   aws        finley007       Available   2022-03-10 22:23:28 +0800 CST   ReadWrite     true
```

## 查看已有恢复
```
velero get restores
```

## 查看 velero 插件
```
velero get plugins
```

## 删除 velero 备份
```
velero backup delete nginx-backup
```

## 持久卷备份
```
velero backup create nginx-backup-volume --snapshot-volumes --include-namespaces nginx-example
```

## 持久卷恢复
```
velero restore create --from-backup nginx-backup-volume --restore-volumes
```

## 创建集群所有namespaces备份，但排除 velero,metallb-system 命名空间
```
velero backup create all-ns-backup --snapshot-volumes=false --exclude-namespaces velero,metallb-system
```

## 周期性定时备份
### 每日3点进行备份
```
$ velero schedule create <SCHEDULE NAME> --schedule "0 3 * * *"
```

### 每日3点进行备份，备份保留48小时，默认保留30天
```
$ velero schedule create <SCHEDULE NAME> --schedule "0 3 * * *" --ttl 48h
```

### 每6小时进行一次备份
```
$ velero create schedule <SCHEDULE NAME> --schedule="@every 6h"
```

### 每日对 web namespace 进行一次备份
```
$ velero create schedule <SCHEDULE NAME> --schedule="@every 24h" --include-namespaces web
```

# 参考
- [k8s-基础-使用Velero备份恢复集群][0]
- [11、Velero + minio（备份容灾）][1]
- [k8s集群备份与迁移][2]

[0]: https://blog.mafeifan.com/DevOps/K8s/k8s-%E5%9F%BA%E7%A1%80-%E4%BD%BF%E7%94%A8Velero%E5%A4%87%E4%BB%BD%E6%81%A2%E5%A4%8D%E9%9B%86%E7%BE%A4.html
[1]: https://blog.csdn.net/weixin_44797299/article/details/136007213
[2]: https://mp.weixin.qq.com/s/Ywc2nQdM398w0wlQi_Z0Ow
