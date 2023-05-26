## 如果想让ingress转发四层tcp请求
1.在ingress的svc里面打上对应端口号的补丁，以jumpserver举例：
vim jms-koko.yaml
```
spec:
  ports:
  - name: jms-koko
    port: 2222
    protocol: TCP
    targetPort: 2222
```

2.给ingress的svc打补丁
```
kubectl patch svc ingress-nginx-controller -n ingress-nginx --patch-file=jms-koko.yaml
```

3.检查ingress svc，是不是多了2222端口
```
kubectl get svc -n ingress-nginx
```

4.在ingress的configmap里面添加对应的端口号信息
```
kubectl edit configmap ingress-nginx-tcp -n ingress-nginx
```
在`apiVersion`下新增如下内容：
```
data:
  "2222": jms/koko:2222
```
完整内容如下：
```
apiVersion: v1
data:
  "2222": jms/koko:2222
kind: ConfigMap
metadata:
  labels:
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/component: controller
  name: ingress-nginx-tcp
  namespace: ingress-nginx
```
修改之后，ingress会自动reload生效
