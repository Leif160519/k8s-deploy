## 反向代理配置
```
server {
    listen 80;
    server_name send.github.icu;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    server_name send.github.icu;

    ssl_certificate      /etc/nginx/vhost/ssl/STAR.github.icu.pem;
    ssl_certificate_key  /etc/nginx/vhost/ssl/STAR.github.icu.key;

    access_log          /var/log/nginx/send.github.icu_access.log;
    error_log           /var/log/nginx/send.github.icu_error.log;

    location /api/ws {
        proxy_redirect           off;
        proxy_pass               http://mozilla-send.devops.svc:1443;
        proxy_http_version       1.1;
        proxy_set_header         Upgrade $http_upgrade;
        proxy_set_header         Connection "upgrade";
        proxy_set_header         Host $http_host;
    }

    location / {
        proxy_set_header        Host $host;
        proxy_set_header        X-Real-IP $remote_addr;
        proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass              http://mozilla-send.devops.svc:1443;
    }
}
```
