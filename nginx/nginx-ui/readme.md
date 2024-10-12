## 参考
- [推荐一个非常牛皮的nginx图形管理项目][1]
- [0xJacky/nginx-ui][2]

## 配置说明
- web界面中，nginx日志-访问日志/错误日志若无法显示日志，则需要在`app.ini`中修改如下配置：
```
LogDirWhiteList = /var/log/nginx # 添加nginx日志目录
```

> 参考：[config-nginx.md][3]

[1]: https://mp.weixin.qq.com/s/P1QsPd_SXNJH-atvRS1ltg
[2]: https://github.com/0xJacky/nginx-ui
[3]: https://github.com/0xJacky/nginx-ui/blob/96cff98c66deba24a20fdde4c6722896f3617680/docs/zh_CN/guide/config-nginx.md
