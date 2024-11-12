## jenkins接入jvm监控

- 1.构建镜像
```
docker build . -t harbor.github.icu/jenkins:2.484-jmx_0.19.0
```

- 2.上传镜像到私有仓库
```
docker push harbor.github.icu/jenkins:2.484-jmx_0.19.0
```

- 3.创建jmx配置文件configmap
```
kubectl apply -f configmap.yaml
```

- 4.重新部署jenkins
```
kubectl apply -f deployment.yaml
```

- 5.更新service
```
kubectl apply -f service-clusterip.yaml
```

- 6.更新prometheus配置
```
- job_name: jmx
  static_configs:
  - targets:
    - jenkins.devops.svc:9999
```

## 说明
- 若添加宿主机的node节点无法通过ssh方式启动

> jenkins:2.415版本需要openjdk-11-jre版本即可,若升级到jenkins:2.484版本，则需要同步升级宿主机jdk版本到openjdk-17-jre,并且jnlp的版本也要升级到jenkins/inbound-agent(原先的jenkins/jnlp-slave已[弃用][1])

[jnlp-slave][1]
