## jenkins接入jvm监控

- 1.构建镜像
```
docker build . -t harbor.github.icu/jenkins:2.415-jmx_0.19.0
```

- 2.上传镜像到私有仓库
```
docker push harbor.github.icu/jenkins:2.415-jmx_0.19.0
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
