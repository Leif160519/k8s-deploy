## 前提
请检查每一处的环境变量，按照实际情况进行修改，不可直接使用

## 使用方法
```
kubectl create ns gpt
kubectl create configmap -n gpt fastgpt-config --from-file=config.json
kubectl apply -f .
```

## 已知问题
- mongodb部署必须使用副本集的形式，设计使然
- mongodb无论是deployment还是statefulset形式部署，删除pod之后都会导致集群状态异常，提示以下错误：
```
MongoServerError: node is not in primary or recovering state
```

> 建议statefulset多节点部署或使用外部mongo集群或单独用docker-compose部署,参考[StatefulSet部署Mongodb集群](../database/mongodb/readme.md)
> 若采用mongodb集群(多节点),一定要配置主节点的连接方式，否则fastgpt会提示mongodb连接错误

- oneapi中配置m3e的地址，一定要用`NodePort`类型的svc形式才可以,如：`http://192.168.31.81:32387`
- oneapi中重新配置m3e地址后，需要重启fastgpt和oneapi的pod才能生效

## 参考
- [定制你的AI梦！快速搭建属于自己的本地FastGPT][1]
- [oneapi][2]
- [fastgpt][3]
- [百度文心一言（千帆大模型）聊天API使用指导][4]
- [chatgpt-web][5]
- [ChatGPT-Next-Web][6]

[1]: https://mp.weixin.qq.com/s/ECMU8puDhumDIonfsdYlUA
[2]: https://github.com/songquanpeng/one-api
[3]: https://github.com/labring/fastgpt
[4]: https://cloud.baidu.com/qianfandev/topic/268180
[5]: https://github.com/Chanzhaoyu/chatgpt-web
[6]: https://github.com/Yidadaa/ChatGPT-Next-Web