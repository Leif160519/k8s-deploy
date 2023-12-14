## 异常停止后，启动报错
```
Cannot open local storage '/nexus-data/db/config' with mode=rw
```

解决办法：删除`/nexus-data/db/config`下所有`wal`结尾的文件
```
find /nexus-data/db/config/ -type f -name "*.wal" -delete
```
