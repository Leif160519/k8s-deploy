## 参考资料
https://developer.aliyun.com/article/1005052
https://mp.weixin.qq.com/s/ub49u9ko886oJsZKlqngRA

## jenkins使用mfs文件系统后，构建日志不完整，乱码问题
https://github.com/moosefs/moosefs/discussions/535
mfsseteattr -f nodatacache <jenkins-pv挂载路径>/jobs -r

## 若想用jdk 1.8部署低版本jenkins
- 1.下载jdk1.8安装包
```
wget -c https://nexus.example.com/repository/peanut/jdk/install-java.sh -P jdk/
wget -c https://nexus.example.com/repository/peanut/jdk/jdk-8u201-linux-x64.tar.gz -P jdk/
```

- 2.准备Dockerfile重新编译jenkins镜像：
```
FROM jenkins/jenkins:2.356

USER root

# 下载并安装 JDK 8
COPY jdk /jdk

RUN yes | bash /jdk/install-java.sh -f /jdk/jdk-8u201-linux-x64.tar.gz && find /jdk -delete
ENV JAVA_HOME /usr/lib/jvm/jdk1.8.0_201
ENV PATH /usr/lib/jvm/jdk1.8.0_201/bin:$PATH

USER jenkins
```

- 3.开始构建新镜像
```
docker build . -t docker.example.com/jenkins:2.356-jdk8
```

- 4.登录私有仓库
```
docker login docker.example.com
```

- 5.上传私有镜像
```
docker push docker.example.com/jenkins:2.356-jdk8
```

- 6.修改`5.deployment.yaml`中的镜像地址为`docker.example.com/jenkins:2.356-jdk8`

- 7.部署jenkins
```
kubectl apply -f 5.deployment.yaml
```

## 生成k8s访问凭据token，使之可以操作集群
```
kubectl create serviceaccount admin-user -n default
kubectl create clusterrolebinding admin-user --clusterrole=cluster-admin --serviceaccount=default:admin-user
kubectl create token admin-user -n jms（执行完会自动输出token）
```

注意：
- 1.创建serviceaccount的角色权限必须为cluster-admin，否则访问某些资源会没有权限
- 2.创建token的命令可以重复执行，每次执行会生成不同的token，且旧token不会过期，可以用如下命令验证：
```
kubectl get node --server=https://xxx.8443 --token=xxx --insecure-skip-tls-verify
```
