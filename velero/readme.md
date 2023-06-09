# minio 默认账号密码
minioadmin
minioadmin

# 准备工作
## 1.下载velero二进制文件
```
https://github.com/vmware-tanzu/velero/releases/download/v1.10.3/velero-v1.10.3-linux-amd64.tar.gz
tar -zxvf velero-v1.10.3-linux-amd64.tar.gz
cd velero-v1.10.3-linux-amd64
ln -svf velero-v1.10.3-linux-amd64.tar.gz/velero /usr/bin/velero
```

## 2.安装minio
```
kubectl apply -f 1.namespace -f 2.minio.yaml
```

## 3.创建好bucket和secret id和key

## 4.修改credentials-velero文件内容的id和key

# 安装velero
```
./install.sh
```

注意：若minio用的是集群外的，请修改`s3url=`后面的minio console的地址

# 卸载velero
```
velero uninstall 按y确认
```

# 查看velero状态
```
kubectl get pod -n velero 看velero的pod是否为Running状态
NAME                      READY   STATUS    RESTARTS   AGE
velero-6c94b8f799-7bc5j   1/1     Running   0          13m

velero get backup-locations 看PHASE是否为Available状态，否则会备份失败
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

# 参考
[k8s-基础-使用Velero备份恢复集群][0]

[0]: https://blog.mafeifan.com/DevOps/K8s/k8s-%E5%9F%BA%E7%A1%80-%E4%BD%BF%E7%94%A8Velero%E5%A4%87%E4%BB%BD%E6%81%A2%E5%A4%8D%E9%9B%86%E7%BE%A4.html
