## 集群验证方式
```
$ kubectl exec -it -n midplatform elasticsearch-0 bash
```

### 1.查询集群的健康状态
```
root@elasticsearch-1:/usr/share/elasticsearch# curl http://127.0.0.1:9200/_cluster/health?pretty
{
  "cluster_name" : "docker-cluster",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 3,
  "number_of_data_nodes" : 3,
  "active_primary_shards" : 3,
  "active_shards" : 6,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 100.0
}
```

### 2.检查节点列表
```
root@elasticsearch-1:/usr/share/elasticsearch# curl http://127.0.0.1:9200/_cat/nodes?v          
ip             heap.percent ram.percent cpu load_1m load_5m load_15m node.role   master name
10.244.44.208            44           5   8    4.04    4.69     3.34 cdfhilmrstw -      elasticsearch-2
10.244.127.201           67          22   7    0.05    0.38     0.55 cdfhilmrstw *      elasticsearch-0
10.244.154.249           60           5   6    5.95    5.26     3.13 cdfhilmrstw -      elasticsearch-1
```

### 3.检查索引状态
```
root@elasticsearch-1:/usr/share/elasticsearch# curl http://127.0.0.1:9200/_cat/indices?v
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases ihsGrl8uQ2yMT28JwwARYw   1   1         34            0     62.6mb         31.3mb
```
