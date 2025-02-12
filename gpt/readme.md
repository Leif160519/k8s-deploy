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
- mongodb副本集（k8s）只要是单副本形式部署，删除pod之后都会导致集群状态异常，提示以下错误（docker-compose部署不会）：
```
MongoServerError: node is not in primary or recovering state
```
> 建议statefulset多节点部署mongodb集群,参考[StatefulSet部署Mongodb集群](../database/mongodb/readme.md)
> 若采用mongodb集群(多节点),则fastgpt中mongodb链接方式一定要配置集群连接方式，否则fastgpt会因为找不到主节点提示mongodb连接错误
```
mongodb://root:123456@mongodb-0.:27017,mongodb-1.mongodb.database.svc:27017,mongodb-2.mongodb.database.svc:27017/fastgpt?authSource=admin
```

- oneapi中配置m3e的地址，一定要用`NodePort`类型的svc形式才可以,如：`http://192.168.31.81:32387`,原因暂时未知
- oneapi中重新配置m3e地址后，需要重启fastgpt和oneapi的pod才能生效
- oneapi初始账号：root  密码：123456

## 添加llama大模型
- 1.安装ollama
```
curl -fsSL https://ollama.com/install.sh | sh
```
- 2.安装llama3.1:latest大模型
```
ollama pull llama3.1:latest
```

> 如果是其他大模型，比如deepseek，可以类推`ollama pull deepseek-r1:8b`

- 3.设置ollama服务允许外部服务器访问
  - a.编辑ollama服务文件
  ```
  vim /etc/systemd/system/ollala.service
  ```
  - b.[Service]下新增环境变量
  ```
  Environment="OLLAMA_HOST=0.0.0.0"
  ```
  - c.重启ollama服务
  ```
  systemctl daemon-reload
  systemctl restart ollama
  ```
  - d.验证
  ```
  curl http://<ollama-server>:11434
  Ollama is running
  ```
- 4.oneapi中新增渠道，选择自定义模型，新增llama3.1:latest大模型，名称写llama3.1:latest,模型手动填入llama3.1:latest
- 5.oneapi中新增令牌或者修改令牌，将llama3.1:latest模型添加进去即可

## 参考
- [定制你的AI梦！快速搭建属于自己的本地FastGPT][1]
- [oneapi][2]
- [fastgpt][3]
- [百度文心一言（千帆大模型）聊天API使用指导][4]
- [chatgpt-web][5]
- [ChatGPT-Next-Web][6]
- [DeepSeek-R1本地部署，再也不怕宕机，还有语音功能！][7]
- [FastGPT 一招帮你解决 DeepSeek R1 的卡顿问题][8]

[1]: https://mp.weixin.qq.com/s/ECMU8puDhumDIonfsdYlUA
[2]: https://github.com/songquanpeng/one-api
[3]: https://github.com/labring/fastgpt
[4]: https://cloud.baidu.com/qianfandev/topic/268180
[5]: https://github.com/Chanzhaoyu/chatgpt-web
[6]: https://github.com/Yidadaa/ChatGPT-Next-Web
[7]: https://blog.csdn.net/2401_84204207/article/details/14538991
[8]: https://mp.weixin.qq.com/s/qvUrioKPhTrXlu0WqIDwKw
