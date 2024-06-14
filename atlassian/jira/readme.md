## 使用方法：
```
docker build . -t harbor.github.icu/public/jira-software:9.9.0
docker push harbor.github.icu/public/jira-software:9.9.0
kubectl apply -f .
```

然后进容器跑
```
kubectl exec -it -n atlassian jira-xxxx bash
cd /var/atlassian
java -jar atlassian-agent.jar -d -m report@163.com -n ph-jira -p jira -o https://www.163.com -s <server-id>
```

> `server-id`:`http(s)://jira.example.net/secure/SetupLicense!default.jspa`界面中显示的内容

## 数据库配置
在配置数据库之前创建好数据库即可
