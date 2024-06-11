# 注意
- 脚本或者yaml中的带有github.icu字样的域名为个人内网使用的域名，使用过程中清根据实际情况自行更换


# 若使用了私有docker镜像仓库，请执行以下操作
- 1. 在master节点上登录私有仓库,输入用户名和密码，如果是nexus搭建的，那就是nexus的用户名和密码
```
docker login docker.example.com
```
- 2.登录完成后，会生成认证文件`/root/.docker/config.json`
```
{
	"auths": {
		"docker.example.com": {
			"auth": "YWRtaW46YWRtaW4="
		}
	}
}
```
其中auth后面的内容可以手动生成
```
echo -n "admin:admin" | base64 # admin:admin为nexus的用户名和密码
```

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

# 整合
- 1.初始化命名空间的脚本：`script/init_namespace.sh`

- 2.更新ingress域名证书的脚本：`script/update_ingress_ssl.sh`

- 3.自动拉取镜像并上传到nexus私有docker仓库：`script/docker-proxy.sh`

# 启用历史版本
在deployment中添加`annotations`和`revisionHistoryLimit`字段
```
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: busybox
  namespace: default
  annotations:
    kubernetes.io/change-cause: "2023-06-08 00:00:00"
spec:
  revisionHistoryLimit: 10
  replicas: 1
  selector:
    matchLabels:
      app: busybox
···
```
当deployment内容有需要改动的时候，请同步修改change-cause后面的时间戳（或者其他内容，光修改change-cause只会有一个历史版本）
之后使用如下命令查看历史版本
```
kubectl rollout history deployment busybox
```

# 删除ns之后卡住，一直显示Terminating
以命名空间为`test`为例
1.执行以下命令
```
kubectl proxy

Starting to server on 127.0.0.1:8001
```

2.另开一个终端,创建临时json文件
```
kubectl get ns test -o json > test.json
```

3.编辑test.json文件，从finalizers字段中，删除`kubernetes`值，并保存文件
```
vim test.json

···
    "spec": {
        "finalizers": [
            "kubernetes" //删除之
        ]
    }
···
```

4.执行以下命令，更新命名空间
```
curl -k -H "Content-Type: application/json" -X PUT --data-binary @test.json http://127.0.0.1:8001/api/v1/namespaces/test/finalize
```
> 其中，test根据实际情况进行替换对应的命名空间名称

5.输出一大串json及代表成功，否则即为失败，根据json内容进行排查

6.根据上述步骤，生成批量处理脚本
```
# kubectl proxy

# 另开一个终端
# 输出所有有问题的ns
kubectl get ns | grep -vi active | grep -i termi | awk '{print "kubectl get ns "$1 " -o json > /root/"$1".json"}'  | bash

# 修改json文件

# 更新命名空间
kubectl get ns | grep -vi active | grep -i termi | awk '{print "curl -k -H \"Content-Type: application/json\" -X PUT --data-binary @"$1".json http://127.0.0.1:8001/api/v1/namespaces/"$1"/finalize"  }'  | bash
```

> 若`spec`下没有上述`finalizers`字段内容，则删除`metadata`下`finzlizers`如下内容后执行curl命令即可

```
···
        "finalizers": [                                  //删除之
            "controller.cattle.io/namespace-auth"        //删除之
        ],                                               //删除之
···
```

# 执行创建secret时报错
```
$ kubectl create secret tls github-tls --key STAR.github.icu.key --cert STAR.github.icu.pem -n devops
error: failed to create secret Internal error occurred: failed calling webhook "rancher.cattle.io.secrets": failed to call webhook: Post "https://rancher-webhook.cattle-system.svc:443/v1/webhook/mutation/secrets?timeout=10s": service "rancher-webhook" not found
```

可能是rbac的问题
```
$ kubectl get mutatingwebhookconfigurations
NAME                             WEBHOOKS   AGE
mutating-webhook-configuration   8          238d
rancher.cattle.io                5          237d

$ kubectl get validatingwebhookconfigurations
NAME                               WEBHOOKS   AGE
ingress-nginx-admission            1          238d
metallb-webhook-configuration      7          257d
rancher.cattle.io                  13         237d
validating-webhook-configuration   11         238d
```
查看发现有两个准入控制器，都是以前安装组件时遗留的控制器

删除即可
```
$ kubectl delete mutatingwebhookconfigurations rancher.cattle.io
mutatingwebhookconfiguration.admissionregistration.k8s.io "rancher.cattle.io" deleted

$ kubectl delete validatingwebhookconfigurations rancher.cattle.io
validatingwebhookconfiguration.admissionregistration.k8s.io "rancher.cattle.io" deleted
```

重新创建secert
```
$ kubectl create secret tls github-tls --key STAR.github.icu.key --cert STAR.github.icu.pem -n devops
secret/github-tls created
```

## 参考
- [Kubernetes排障方法][1]

[1]: https://imroc.cc/kubernetes-troubleshooting/methods/
