## 异常停止后，启动报错
### 第一种情况
日志显示：`Cannot open local storage '/nexus-data/db/config' with mode=rw`

解决办法：删除`/nexus-data/db/config`下所有`wal`结尾的文件
```
find /nexus-data/db/config/ -type f -name "*.wal" -delete
```

## 第二种情况
日志显示：
```
Defaulted container "nexus3" out of: nexus3, delete-wal-file (init)
WARNING: ************************************************************
WARNING: Detected execution as "root" user.  This is NOT recommended!
WARNING: ************************************************************
```
解决办法：删除`/nexus-data/db/config`下所有`.lock`结尾的文件
```
find /nexus-data -type f -name "*.lock" -delete
```

## 镜像提交域名反向代理配置建议用nginx非ingress
```
upstream nexus_docker_get {
    server nexus3.devops.svc:8082;
}
 
upstream nexus_docker_put { 
    server nexus3.devops.svc:8083; 
}
server {
    listen 80;
    server_name docker.github.icu;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    server_name docker.github.icu;

    ssl_certificate      /etc/nginx/vhost/ssl/STAR.github.icu.pem;
    ssl_certificate_key  /etc/nginx/vhost/ssl/STAR.github.icu.key;

    # 设置默认使用推送代理 
    set $upstream "nexus_docker_put"; 
    # 当请求是GET，也就是拉取镜像的时候，这里改为拉取代理，如此便解决了拉取和推送的端口统一 
    if ( $request_method ~* 'GET') { 
        set $upstream "nexus_docker_get"; 
    } 
    # 只有本地仓库才支持搜索，所以将搜索请求转发到本地仓库，否则出现500报错
     if ($request_uri ~ '/search') { 
        set $upstream "nexus_docker_put"; 
    }

    location / {
        client_max_body_size    1024M;
        client_body_buffer_size    128k;
        
        proxy_connect_timeout      90;
        proxy_send_timeout         90;
        proxy_read_timeout         90;
        proxy_buffering            off;
        proxy_request_buffering    off;
        proxy_set_header Connection "";
        
        proxy_set_header        Host $host:$server_port;
        proxy_set_header        X-Real-IP $remote_addr;
        proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header        X-Forwarded-Proto $scheme;
        proxy_intercept_errors on;
        error_page  404 /;
        
        # Fix the "It appears that your reverse proxy set up is broken" error.
        proxy_pass          http://$upstream;
        access_log          /var/log/nginx/docker.github.icu_access.log;
        error_log           /var/log/nginx/docker.github.icu_error.log;
    }
}
```
