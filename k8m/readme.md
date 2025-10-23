## 部署
```
kubectl create configmap kube-config --from-file ~/.kube/config -n k8m
kubectl apply -f *.yaml
```
## 说明
用户名和密码都是k8m
