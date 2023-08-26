## 启动statefulset之前请下载sql文件并执行：
```
wget -c https://raw.githubusercontent.com/alibaba/nacos/2.0.3/distribution/conf/nacos-mysql.sql
mysql -u root -p < nacos-mysql.sql
```

## 关于为何要两个svc(By ChatGPT)
> 在 Kubernetes 中，当您使用 StatefulSet 搭建 Nacos 集群时，建议将关联的 Service 配置为 Headless Service（将 clusterIP 设置为 None）。这是因为 Headless Service 为 StatefulSet 提供了稳定的网络标识和 DNS 解析，这对于 Nacos 集群中的节点之间的通信是非常重要的。
当您将 Service 的 clusterIP 设置为 None 时，Kubernetes 将不会为该服务分配一个虚拟 IP。相反，它将为 StatefulSet 的每个 Pod 创建一个唯一的 DNS 主机名，例如 nacos-0.nacos-headless.default.svc.cluster.local。这样，每个 Nacos 节点都可以通过其 DNS 主机名进行访问，而不需要依赖于虚拟 IP，从而确保了在集群中的节点之间的稳定通信。
此外，使用 Headless Service 还可以确保 Nacos 集群在扩展或缩小时保持一致。当您增加或减少 StatefulSet 的副本数时，Kubernetes 将自动为新的 Pod 分配唯一的 DNS 主机名，并更新 DNS 记录。这使得 Nacos 集群能够在运行时动态调整其大小，同时保持集群之间的通信和数据一致性。
总之，将 clusterIP 设置为 None 以创建 Headless Service 是为了确保 Nacos 集群中的节点之间的稳定通信和动态扩展能力。
