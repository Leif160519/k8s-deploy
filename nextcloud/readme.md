## 用法参考
- [dockerhub/nextcloud][1]
- [nextcloud/docker][2]

## 注意
- 首次部署的时候，大概需要5分钟才能全部初始化完成，html文件夹大小大概为700MB+，所以deployment.yaml中去掉了健康检查，可以在初始化过后加上
- 配置nextcloud客户端的时候，会提示""，解决办法参考：[NextCloud 使用https反向代理后PC端异常][3]

[1]: https://hub.docker.com/_/nextcloud
[2]: https://github.com/nextcloud/docker
[3]: https://www.cnblogs.com/mouseleo/p/15516828.html
