## 使用方法
先将prometheus.yml复制到pvc的prometheus目录中，之后执行yaml

## 如果prometheus中配置的victoria地址为域名，非svc写法，则不需要rbac，否则需要创建rbac并且重新创建prometheus pod

## 注意
prometheus自己的存储建议选择nfs，不要选择moosefs，因为moosefs写入会有问题，可能与文件系统缓存有关，但没有经过验证
