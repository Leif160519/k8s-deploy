## 使用方法
先将prometheus.yml复制到pvc的prometheus目录中，之后执行yaml

## 如果prometheus中配置的victoria地址为域名，非svc写法，则不需要rbac，否则需要创建rbac并且重新创建prometheus pod
