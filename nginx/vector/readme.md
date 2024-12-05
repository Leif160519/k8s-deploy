## 使用步骤
- 1.搭建[clickhouse][2]
- 2.根据nginx日志存储情况和clickhouse的信息更改configmap内容
- 3.`kubectl apply -f .`
- 4.第一次启动vector会失败，但是会在pvc中创建对应的路径，在<pvc-dir>/vector/logs下新建日志文件`access_vector_error.log`;将`GeoLite2-City.mmdb`复制到<pvc-dir>/vector/mmdb下，重新启动vector
- 5.grafana安装clickhouse插件:`grafana-cli plugins install grafana-clickhouse-datasource`，安装成功后重启grafana
- 6.添加clickhouse数据源并配置认证信息和数据库信息
- 7.等待一段时间vector分析后会自动展示数据，可以通过`vector top`命令查看状态

> mmdb文件在付费附件中，不定时更新

## 参考
- [你还用ES存请求日志？CH+Vector打造最强Grafana日志分析看板][1]

[1]: https://mp.weixin.qq.com/s?__biz=MzAwNzQ3MDIyMA==&mid=2247485456&idx=1&sn=1ed46f388d34041faae6ede651559fd1&chksm=9b7ce5f3ac0b6ce59f9b4ab1ff48f9acf149692c5df09990b8485d4ec40ebed6e3ab66af8d73&scene=178&cur_album_id=3669478369130889224#rd
[2]: ../../database/clickhouse
