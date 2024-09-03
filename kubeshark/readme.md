## Kubeshark安装
```
sh <(curl -Ls https://kubeshark.co/install)
# 或者使用以下命令指定版本
curl -Lo kubeshark https://github.com/kubeshark/kubeshark/releases/download/41.6/kubeshark_linux_amd64 && chmod 755 kubeshark
```

> 其他方法可以在https://docs.kubeshark.co/en/install找到

## 启动流量捕获
```
kubeshark tap
```

## 启用仪表盘访问
```
kubectl port-forward service/kubeshark-front 8899:80
```

> 访问 `http://localhost:8899`即可查看 Kubeshark 的仪表盘。

或者使用ingress
```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  labels:
    app.kubernetes.io/instance: kubeshark
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/name: kubeshark
    app.kubernetes.io/version: 52.3.79
    helm.sh/chart: kubeshark-52.3.79
  name: kubeshark-front
  namespace: default
spec:
  ingressClassName: nginx
  rules:
  - host: kubeshark.github.icu
    http:
      paths:
      - backend:
          service:
            name: kubeshark-front
            port:
              number: 80
        path: /
        pathType: Prefix
  tls:
  - hosts:
    - kubeshark-front.github.icu
    secretName: github-tls
```

## 参考资料
- [KubeShark: Kubernetes的Wireshark][1]

[1]: https://www.jianshu.com/p/c7eb8d83beaf
