## 使用方法
```
kubectl apply -f 1.rbac.yaml
kubectl apply -f 2.configmap.yaml
kubectl apply -f 3.pvc.yaml
kubectl apply -f 4.service-clusterip.yaml
kubectl apply -f 5.service-clusterip.yaml
kubectl apply -f 6.deployment.yaml
```

## 更新配置
```
kubectl edit configmap prometheus-config -n monitoring
```
> 更新后configmap-reload容器会自动重载prometheus配置,延迟大概在2分钟以内

## 如果prometheus中配置的victoria地址为域名，非svc写法，则不需要rbac，否则需要创建rbac并且重新创建prometheus pod

## 注意
~~prometheus自己的存储建议选择nfs，不要选择moosefs，因为moosefs写入会有问题，可能与文件系统缓存有关，但没有经过验证~~

~~经过验证，可以使用moosefs作为sc，但是跟jenkins一样，得需要执行`mfsseteattr -f nodatacache <prometheus-pv挂载路径> -r`~~
> 截至2024/04/26使用情况观测，使用moosefs的sc还是会导致prometheus崩溃，报错，所以建议还是使用nfs
```
Defaulted container "prometheus" out of: prometheus, configmap-reload, delete-wal-lock-file (init)

ts=2024-04-26T14:21:56.364Z caller=main.go:583 level=info msg="Starting Prometheus Server" mode=server version="(version=2.48.1, branch=HEAD, revision=63894216648f0d6be310c9d16fb48293c45c9310)"

ts=2024-04-26T14:21:56.365Z caller=main.go:588 level=info build_context="(go=go1.21.5, platform=linux/amd64, user=root@71f108ff5632, date=20231208-23:33:22, tags=netgo,builtinassets,stringlabels)"

ts=2024-04-26T14:21:56.365Z caller=main.go:589 level=info host_details="(Linux 5.4.0-176-generic #196-Ubuntu SMP Fri Mar 22 16:46:39 UTC 2024 x86_64 prometheus-6d4ff87749-l7r5t (none))"

ts=2024-04-26T14:21:56.365Z caller=main.go:590 level=info fd_limits="(soft=1048576, hard=1048576)"

ts=2024-04-26T14:21:56.365Z caller=main.go:591 level=info vm_limits="(soft=unlimited, hard=unlimited)"

ts=2024-04-26T14:21:56.367Z caller=query_logger.go:105 level=error component=activeQueryTracker msg="Failed to mmap" file=/var/lib/prometheus/queries.active Attemptedsize=20001 err="no such device"

panic: Unable to create mmap-ed active query log



goroutine 1 [running]:

github.com/prometheus/prometheus/promql.NewActiveQueryTracker({0x7ffcd7a1c6c8, 0x13}, 0x14, {0x3e94bc0, 0xc0008a1360})

    /app/promql/query_logger.go:123 +0x411

    main.main()

        /app/cmd/prometheus/main.go:645 +0x7812
```
修改存储类型的方式：
  - 1.将prometheus的副本设置为0
  - 2.删除prometheus数据存储的pvc
  - 3.创建nfs存储的pvc
  - 4.将prometheus的副本数设置为1

## 参考
https://github.com/jimmidyson/configmap-reload
