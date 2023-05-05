## gitlab使用外部postgresql和redis
https://www.cnblogs.com/linkenpark/p/8359216.html

## gitlab-ce安装
```
kubectl apply -f 1.namespace.yaml
·
·
·
kubectl apply -f 6.deployment.yaml
```

## 设置22端口的tcp转发
- 1.kubectl patch svc nginx -n devops --patch-file=8.patch.nginx.lb.yaml
- 2.在nginx的pvc里新建一个tcp文件夹，把7.gitlab-ssh.tcp文件放进去
- 3.刷新nginx配置
