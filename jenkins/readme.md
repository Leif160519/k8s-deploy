## 参考资料
https://developer.aliyun.com/article/1005052
https://mp.weixin.qq.com/s/ub49u9ko886oJsZKlqngRA

## jenkins使用mfs文件系统后，构建日志不完整，乱码问题
https://github.com/moosefs/moosefs/discussions/535
mfsseteattr -f nodatacache <jenkins-pv挂载路径>/jobs -r
