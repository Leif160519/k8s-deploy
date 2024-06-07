## gitlab使用外部postgresql和redis
https://www.cnblogs.com/linkenpark/p/8359216.html

## gitlab-ce安装
```
kubectl apply -f .
```

## 设置22端口的tcp转发
- 1.kubectl patch svc nginx -n devops --patch-file=8.patch.nginx.lb.yaml
- 2.在nginx的pvc里新建一个tcp文件夹，把7.gitlab-ssh.tcp文件放进去
- 3.刷新nginx配置

## 如果gitlab反复起不来的话
```
kubectl exec -it -n gitlab gitlab-xxx -- bash
gitlab-ctl restart # 等待大概10分钟就能正常进入界面了，如果提示We're sorry. GitLab is taking too much time to respond.稍微等待一会
```
