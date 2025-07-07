## 依赖：
- consul-server
- postgresql

## 注意
- `KONG_PG_HOST`：必须写postgresql的svcip地址，否则无法解析
- `KONG_DNS_RESOLVER`：必须写consul-server的svc地址，否则无法解析
