## jumpserver安装
kubectl apply -f 1.namespace.yaml
·
·
·
kubectl apply -f 10.jms-web.yaml

## 设置koko 2222端口的tcp转发
1.kubectp patch svc nginx -n devops --patch-file=11.patch.nginx.lb.yaml
2.在nginx的pvc里新建一个tcp文件夹，把12.jms-koko.tcp文件放进去
3.刷新nginx配置
