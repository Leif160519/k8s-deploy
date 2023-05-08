## jumpserver安装
```
kubectl apply -f 0.pvc-mfs.yaml
kubectl apply -f 1.namespace.yaml
·
·
·
kubectl apply -f 9.jms-web.yaml
```
注意：core部署时需要初始化数据库，时间大概为5分钟，故去掉了健康检查

## 设置koko 2222端口的tcp转发
- 1.kubectp patch svc nginx -n devops --patch-file=11.patch.nginx.lb.yaml
- 2.在nginx的pvc里新建一个tcp文件夹，把12.jms-koko.tcp文件放进去
- 3.刷新nginx配置

## 创建jumpserver访问k8s集群的访问token
kubectl apply -f 10.jms-token.yaml
kubectl get sa -n jms | grep admin-user
kubectl describe secrets admin-user-token-xxx
