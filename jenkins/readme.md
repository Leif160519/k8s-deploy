## 参考资料
https://developer.aliyun.com/article/1005052
https://mp.weixin.qq.com/s/ub49u9ko886oJsZKlqngRA

## jenkins使用mfs文件系统后，构建日志不完整，乱码问题
https://github.com/moosefs/moosefs/discussions/535
mfsseteattr -f nodatacache <jenkins-pv挂载路径>/jobs -r

## 若想用jdk 1.8部署低版本jenkins
1.下载jdk1.8安装包
```
wget -c https://nexus.github.icu/repository/peanut/jdk/install-java.sh -P jdk/
wget -c https://nexus.github.icu/repository/peanut/jdk/jdk-8u201-linux-x64.tar.gz -P jdk/
```

2.准备Dockerfile重新编译jenkins镜像：
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

3.开始构建新镜像
```
docker build . -t docker.github.icu/jenkins:2.356
```

4.登录私有仓库
```
docker login docker.github.icu
```

5.上传私有镜像
```
docker push docker.github.icu/jenkins:2.356
```

6.修改`5.deployment.yaml`中的镜像地址为`docker.github.icu/jenkins:2.356`

7.部署jenkins
```
kubectl apply -f 5.deployment.yaml
```
