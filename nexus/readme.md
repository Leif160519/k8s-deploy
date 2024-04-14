## 异常停止后，启动报错
### 第一种情况
日志显示：`Cannot open local storage '/nexus-data/db/config' with mode=rw`

解决办法：删除`/nexus-data/db/config`下所有`wal`结尾的文件
```
find /nexus-data/db/config/ -type f -name "*.wal" -delete
```

## 第二种情况
日志显示：
```
Defaulted container "nexus3" out of: nexus3, delete-wal-file (init)
WARNING: ************************************************************
WARNING: Detected execution as "root" user.  This is NOT recommended!
WARNING: ************************************************************
```
解决办法：删除`/nexus-data/db/config`下所有`.lock`结尾的文件
```
find /nexus-data -type f -name "*.lock" -delete
```
