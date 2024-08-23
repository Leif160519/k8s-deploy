## 前提
请检查每一处的环境变量，按照实际情况进行修改，不可直接使用

## 使用方法
```
kubectl create ns gpt
kubectl create configmap -n gpt fastgpt-config --from-file=config.json
kubectl apply -f .
```

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
