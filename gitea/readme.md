## 如果想让ingress转发四层tcp请求
- 1.在ingress的svc里面打上对应端口号的补丁：
vim 5.gitea-ssh.yaml
```
spec:
  ports:
  - name: gitea-ssh
    port: 22
    protocol: TCP
    targetPort: 22
```

- 2.给ingress的svc打补丁
```
kubectl patch svc ingress-nginx-controller -n ingress-nginx --patch-file=5.gitea-ssh.yaml
```

- 3.检查ingress svc，是不是多了22端口
```
kubectl get svc -n ingress-nginx
```

- 4.在ingress的configmap里面添加对应的端口号信息
```
kubectl edit configmap ingress-nginx-tcp -n ingress-nginx
```
在`apiVersion`下新增如下内容：
```
data:
  "22": gitea/gitea:22
```
完整内容如下：
```
apiVersion: v1
data:
  "22": gitea/gitea:22
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
