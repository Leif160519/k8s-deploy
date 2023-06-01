# 若使用了私有docker镜像仓库，请执行以下操作
- 1. 在master节点上登录私有仓库,输入用户名和密码，如果是nexus搭建的，那就是nexus的用户名和密码
```
docker login docker.example.com
```
- 2.登录完成后，会生成认证文件`/root/.docker/config.json`

- 3.在每个命名空间下，创建用于认证docker私有仓库的secret
```
kubectl create secret generic registry-auth -n ${NAMESPACE} --from-file=.dockerconfigjson=/root/.docker/config.json --type=kubernetes.io/dockerconfigjson
```

- 4.在deployment的配置文件中，加上docker认证的secret
```
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
    - name: my-container
      image: docker.example.com/my-image:1.0
  imagePullSecrets:
    - name: registry-auth
```

# 若使用了ingress，如何创建域名证书secret
- 1.将证书放在/root或者其他目录下,域名为example.com

- 2.在每个需要部署ingerss的ns下，执行以下命令
```
kubectl create secret tls example-tls --key ${TLS_PATH_KEY} --cert ${TLS_PATH_CRT} -n ${NAMESPACE}
```

# 若ingress使用的证书到期了，如何更新证书
- 1.查找出使用某域名的ns,域名为example.com
```
kubectl get ing -A |grep example |awk '{print $1}'|uniq |xargs 
```

- 2.删除这些命名空间下的证书secret
```
kubectl delete secret example-tls -n $NAMESPACE
```

- 3.重新创建证书secret
```
kubectl create secret tls example-tls --key ${TLS_PATH_KEY} --cert ${TLS_PATH_CRT} -n ${NAMESPACE}
```

- 4.ingress控制器会自动更新证书并reload

# 初始化命名空间的脚本：`init_namespace.sh`

# 更新ingress域名证书的脚本：`update_ingress_ssl.sh`
