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
### 方法一：k8s版本低于1.24,自动生成token
```
kubectl apply -f 10.jms-token.yaml
kubectl get sa -n jms | grep admin-user
kubectl describe secrets admin-user-token-xxx -n jms | grep token
或者
kubectl get secret $(kubectl -n jms get secret | grep admin-user | awk 'NR==1{print $1}') -n jms -o go-template='{{.data.token}}' | base64 -d
```

### 方法二：k8s版本高于1.24，手动生成token
集群版本为1.24以上，则创建serviceaccount资源的时候，集群不会自动创建对应的secret token,这时需要手动创建token,并设置过期时间（示例为1年）
在`10.jms-token.yaml`下追加以下内容
```
---
apiVersion: v1
kind: Secret
metadata:
  name: admin-user
  annotations:
    kubernetes.io/service-account.name: "admin-user"
  namespace: jms
type: kubernetes.io/service-account-token
```

创建token
```
kubectl apply -f 10.jms-token.yaml
kubectl get secret $(kubectl -n jms get secret | grep admin-user | awk 'NR==1{print $1}') -n jms -o go-template='{{.data.token}}' | base64 -d
```

或者不用套用yaml，直接手动创建
```
kubectl create serviceaccount admin-user -n jms
kubectl create clusterrolebinding admin-user --clusterrole=cluster-admin --serviceaccount=jms:admin-user
kubectl create token admin-user -n jms --duration 8760h（执行完会自动输出token）
```

注意：
- 1.创建serviceaccount的角色权限必须为cluster-admin，否则访问某些资源会没有权限
- 2.创建token的命令可以重复执行，每次执行会生成不同的token，不指定过期时间的情况下，每次创建的token有效期为24h，token有效性可以用如下命令验证：
```
kubectl get node --server=https://xxx.8443 --token=xxx --insecure-skip-tls-verify
```

## token的使用
将上述token填写到jumperver的资产管理->统用户->创建系统用户，类型选择kubernetes，将token填写进去，之后将k8s应用与系统用户绑定即可

## jms_all
若不想逐个部署jumpserver的各个组件，可以使用jms_all文件夹里的配置文件，使用jms_all镜像进行统一部署

注意：jms_all的最后一个版本为v2.28.7，且已经停止维护
