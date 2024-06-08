## 用法参考
- [dockerhub/nextcloud][1]
- [nextcloud/docker][2]

## 注意
- 首次部署的时候，大概需要5分钟才能全部初始化完成，html文件夹大小大概为400MB+，所以deployment.yaml中去掉了健康检查，可以在初始化过后加上
- 部署ingress后，请在`config/config.php`中修改`trusted_domains`为nextcloud实际的访问域名(https),env中设置`NEXTCLOUD_TRUSTED_DOMAINS`并不起作用
```
'''
  'trusted_domains' =>
    array (
        0 => 'nextcloud.github.icu',
          ),
'''
```

[1]: https://hub.docker.com/_/nextcloud
[2]: https://github.com/nextcloud/docker
