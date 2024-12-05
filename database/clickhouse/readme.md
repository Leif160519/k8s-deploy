## 生成密码(返回的第一行是明文，第二行是密文)

```
PASSWORD=$(base64 < /dev/urandom | head -c8); echo "$PASSWORD"; echo -n "$PASSWORD" | sha256sum | tr -d '-'

ggnCNbwr
dd1aec5a29cc9c38e1081066765edd5dc8a121a8bc000dd525b44d32443cb7cb
```
