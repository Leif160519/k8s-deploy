alertmanager.yml配置文件中，在webhook_configs下添加如下配置，才能让alerta收到告警
```
- url: 'http://alerta-web:8080/api/webhooks/prometheus'
  http_config:
    basic_auth:
      username: admin@alerta.io
      password: alerta
```
