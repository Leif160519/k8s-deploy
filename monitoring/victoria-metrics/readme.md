## 注意
- 如果Vitoria的日志中显示因为某个指标附带了大量的标签，超过了其内部设置的标签限制（可能是为了性能和存储得效率考虑），会丢弃超出得指标，则可以在Vitoria的启动参数中添加下列内容，允许更多的标签
```
-maxLabelsPerTimeseries=200
```
> 改完了一般查询会非常卡，甚至影响整个集群性能，调整需谨慎,建议查询一下各个k8s集群节点是否被打了一些不需要的标签
