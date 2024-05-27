## 零、使用方法
1.依次执行
```
kubectl create configmap -n sonarqube sonarqube-config --from-file=conf/sonar.properties --from-file=conf/wrapper.conf
kubectl apply -f 1.namespace.yaml
kubectl apply -f 2.pvc-mfs.yaml
kubectl apply -f 3.postgresql.yaml
kubectl apply -f 4.service-clusterip.yaml
kubectl apply -f 5.service-ingress.yaml
kubectl apply -f 6.deployment.yaml
```
2.查找到sonarqube对应的pv
```
kubectl get pv | grep sonarqube
```

3.extension路径覆盖pv里的内容


## 一、注意
 > - 注意：sonarqube从7.9开始已经不支持mysql数据库了，7.8是最后一个版本（lts版本也是7.9的）
 > - 安装sonarqube比较占用cpu和内存资源，运行之前确保配置足够（建议四核，8GB内存以上）
 > - sonarqube汉化教程:[SonarQube基础：中文设定设定方法](https://blog.csdn.net/liumiaocn/article/details/103043922)
 > - 汉化包下载地址:[xuhuisheng/sonar-l10n-zh](https://github.com/xuhuisheng/sonar-l10n-zh/releases/)

## 二、常见问题和解决方案
### 1
若日志中提示"max virtual memory areas vm.max_map_count [65530] is too low"这个错误，请将sonarqube pod所在的node节点的`/etc/sysctl.conf`配置文件的最后一行添加`vm.max_map_count=655360`之后使用`sysctl -p`命令生效。


### 2
sonarqube分析代码失败，提示`OutOfMemoryError:Java heap space`

对于代码亮巨大的项目来说，堆内存不足容易引起sonarqube分析失败，解决办法:

```
sed -i "s/^#sonar.ce.javaOpts=/csonar.ce.javaOpts=-Xmx3036m -Xms1024m -XX:+HeapDumpOnOutOfMemoryError/g" /opt/sonarqube/conf/sonar.properties
```

参考:[Sonar问题解决：OutOfMemoryError:Java heap space(linux)](https://zhuanlan.zhihu.com/p/128500015)

### 3
若使用的是mysql作为sonarqube的数据存储，在分析后失败，报错`outofmemory`的，一般是sql语句的字节数超过了mysql的限制导致的，建议在mysql的配置文件中改大`max_allowed_packet`的值即可解决。

## 5.安装分支插件，且配置branch.name之后报错
查看参考3

## 6.sonarqube停止之后无法启动，报错：(deployment中已解决)
```
java.lang.IllegalStateException: failed to obtain node locks, tried [[/opt/sonarqube/data/es7]] with lock id [0]; maybe these locations are not writable or multiple nodes were started without increasing [node.max_local_storage_nodes] (was [1])?
        at org.elasticsearch.env.NodeEnvironment.<init>(NodeEnvironment.java:328)
        at org.elasticsearch.node.Node.<init>(Node.java:427)
        at org.elasticsearch.node.Node.<init>(Node.java:309)
        at org.elasticsearch.bootstrap.Bootstrap$5.<init>(Bootstrap.java:234)
        at org.elasticsearch.bootstrap.Bootstrap.setup(Bootstrap.java:234)
        at org.elasticsearch.bootstrap.Bootstrap.init(Bootstrap.java:434)
        at org.elasticsearch.bootstrap.Elasticsearch.init(Elasticsearch.java:166)
        at org.elasticsearch.bootstrap.Elasticsearch.execute(Elasticsearch.java:157)
        at org.elasticsearch.cli.EnvironmentAwareCommand.execute(EnvironmentAwareCommand.java:77)
        at org.elasticsearch.cli.Command.mainWithoutErrorHandling(Command.java:112)
        at org.elasticsearch.cli.Command.main(Command.java:77)
        at org.elasticsearch.bootstrap.Elasticsearch.main(Elasticsearch.java:122)
        at org.elasticsearch.bootstrap.Elasticsearch.main(Elasticsearch.java:80)
For complete error details, refer to the log at /opt/sonarqube/logs/sonarqube.log
2024.05.29 00:44:34 WARN  app[][o.s.a.p.AbstractManagedProcess] Process exited with exit value [es]: 1
2024.05.29 00:44:34 INFO  app[][o.s.a.SchedulerImpl] Process[es] is stopped
2024.05.29 00:44:34 INFO  app[][o.s.a.SchedulerImpl] SonarQube is stopped
```

解决方案：将es7下面的所有lock结尾的文件删除
```
find /opt/sonarqube/data/es7 -type f -name "*.lock" -delete
```


## 三、补充插件

- [SonarQube社区版分支插件V1.3.0更新](https://cloud.tencent.com/developer/article/1624836)

## 四、参考资料
- [质量管理平台集成](http://docs.idevops.site/jenkins/pipelineintegrated/chapter04/)
- [The Chinese translation pack for SonarQube](https://github.com/xuhuisheng/sonar-l10n-zh)
- [plugin installed, still sonarq reports "Current edition does not support branch feature"](https://github.com/mc1arke/sonarqube-community-branch-plugin/issues/663)
- [Sonarqube Community Branch Plugin](https://github.com/mc1arke/sonarqube-community-branch-plugin)
- [SonarQube配置LDAP认证集成](https://www.cnblogs.com/mascot1/p/9963594.html)
