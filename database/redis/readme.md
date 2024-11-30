## 前提条件
如果redis采用moosefs作为文件存储，则需要设置数据文件夹属性`mfsseteattr -f nodatacache -r <redis-data-pvc-dir>`,否则如果遇到异常关机的情况，会导致aof文件损坏引起redis数据丢失的情况

## 执行步骤
```
kubectl apply -f .
```

> redisinsight是redis的可视化界面

## 参考
- [Redisinsight/Redisinsight][1]

[1]: https://github.com/RedisInsight/RedisInsight
