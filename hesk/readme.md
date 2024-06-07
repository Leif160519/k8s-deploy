## 说明
1.目录结构
```
hesk
├── 1.deployment.yml
├── 2.service.yml
├── Dockerfile
├── hesk345.zip
├── readme.md
└── zh_cmn_hans.zip
```

- hesk345.zip: hesk免费版安装包
- zh_cmn_hans.zip: hesk中文汉化包
- my.cnf: mysql数据库配置文件

## 使用方法
```
docker build . -t harbor.github.icu/peanut-public/hesk:latest
docker push harbor.github.icu/peanut-public/hesk:latest
kubectl apply -f .
```

## 初始化安装
浏览器访问：https://hesk.github.icu/hesk/install,点击click hear to install hesk，按照提示操作即可
设置好数据库后，exec到pod中删除install目录，刷新网页即可进入hesk

## 参考资料
- [安装部署一套免费的HESK服务台工单系统][1]
- [Download Free Help Desk Software][2]
- [Hesk Chinese Simplified][3]

[1]: https://blog.csdn.net/Junson142099/article/details/112945887
[2]: https://www.hesk.com/download.php
[3]: https://www.hesk.com/language/info.php?tag=zh_cmn_hans
