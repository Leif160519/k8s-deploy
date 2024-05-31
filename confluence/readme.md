## 使用方法：
若confluence使用ingress访问https形式，则为了避免登录confluence后总是出现`base url`的警告，可以先将server.xml的`confluence.example.net`域名改为你实际的域名
之后执行：
```
docker build . -t harbor.github.icu/peanut-public/confluence-server:8.5.2
docker push harbor.github.icu/peanut-public/confluence-server:8.5.2
kubectl create configmap -n devops confluence-config --from-file=server.xml
kubectl apply -f .
```

然后进容器跑
```
kubectl exec -it -n devops confluence-xxxx bash
cd /var/atlassian
java -jar atlassian-agent.jar -d -m test@test.com -n test@test.com -p conf -o http://localhost:8090 -s <server-id>
```

> `server-id`:`http(s)://confluence.example.net/setup/setuplicense.action`界面中显示的内容

## 数据库配置
建议写jdbc的形式：
```
jdbc:mysql://mysql:3306/confluence?sessionVariables=transaction_isolation='READ-COMMITTED'
```

> 若提示collation错误，则修改mysql配置文件，参考[configure mysql server][1],如果修改字符集之前confluence数据库已经创建好，在修改玩字符集之后删除这个库，重新创建即可通过mysql检测


[1]: https://confluence.atlassian.com/doc/database-setup-for-mysql-128747.html
