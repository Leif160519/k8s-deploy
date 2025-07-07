## 使用方法
- 构建
```
docker build . -t harbor.github.icu/library/konga:latest
```

- 推送镜像
```
docker push harbor.github.icu/library/konga:latest
```

- 部署
```
kubectl apply -f .
```

## 注意
- konga的最新版五年前更新的，驱动需要更新，所以需要重新构建镜像，而且搭配的postgresql版本要跟驱动支持的版本范围一致
