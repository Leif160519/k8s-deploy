## 使用方法
```
kubectl apply -f 1.namespace.yaml
kubectl create configmap -n veops cmdb-db-config --from-file=mysqld.cnf
kubectl create configmap -n veops cmdb-db-sql --from-file=cmdb.sql
kubectl create configmap -n veops cmdb-ui-config --from-file=cmdb.conf
kubectl create -f .
```

## 参考
- [veops/cmdb][1]

- [1]: https://github.com/veops/cmdb
