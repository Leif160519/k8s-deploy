## 前提条件
如果redis采用moosefs作为文件存储，则需要设置数据文件夹属性`mfsseteattr -f nodatacache -r <redis-data-pvc-dir>`,否则如果遇到异常关机的情况，会导致aof文件损坏引起redis数据丢失的情况
> 如果遇到redis无法启动，且日志提示aof损坏需要修复的情况：
```
1:M 30 Nov 2024 17:09:48.536 * Running mode=standalone, port=6379.
1:M 30 Nov 2024 17:09:48.538 # Server initialized
1:M 30 Nov 2024 17:09:48.542 * Reading RDB preamble from AOF file...
1:M 30 Nov 2024 17:09:48.544 * Loading RDB produced by version 6.2.14
1:M 30 Nov 2024 17:09:48.546 * RDB age 173072 seconds
1:M 30 Nov 2024 17:09:48.548 * RDB memory usage when created 3.76 Mb
1:M 30 Nov 2024 17:09:48.549 * RDB has an AOF tail
1:M 30 Nov 2024 17:09:48.555 # Done loading RDB, keys loaded: 47, keys expired: 0.
1:M 30 Nov 2024 17:09:48.557 * Reading the remaining AOF tail...
1:M 30 Nov 2024 17:09:49.171 # Bad file format reading the append only file: make a backup of your AOF file, then use ./redis-check-aof --fix <filename>
```

则修复之
```
$ redis-check-aof --fix redis.aof

The AOF appears to start with an RDB preamble.
Checking the RDB preamble to start:
[offset 0] Checking RDB file --fix
[offset 27] AUX FIELD redis-ver = '6.2.14'
[offset 41] AUX FIELD redis-bits = '64'
[offset 53] AUX FIELD ctime = '1732784716'
[offset 68] AUX FIELD used-mem = '3937560'
[offset 84] AUX FIELD aof-preamble = '1'
[offset 86] Selecting DB ID 0
[offset 335824] Checksum OK
[offset 335824] \o/ RDB looks OK! \o/
[info] 47 keys read
[info] 12 expires
[info] 12 already expired
RDB preamble is OK, proceeding with AOF tail...
0x         13aef42: Expected prefix '*', got: '
AOF analyzed: size=29190082, ok_up_to=20639554, diff=8550528
This will shrink the AOF from 29190082 bytes, with 8550528 bytes, to 20639554 bytes
Continue? [y/N]: y
Successfully truncated AOF
```

删除redis的pod让其重建即可正常启动

> 以上方案也适用于redis单节点

## 执行步骤
```
kubectl apply -f .
```

> redisinsight是redis的可视化界面

## 参考
- [Redisinsight/Redisinsight][1]

[1]: https://github.com/RedisInsight/RedisInsight
