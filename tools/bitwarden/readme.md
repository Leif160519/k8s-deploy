## 环境变量
- ADMIN_TOKEN

使用如下命令生成
```
openssl rand -base64 48
```

- DOMAIN

实际访问bitwarden的域名地址

## 注意：
- 首次登录之前确保`SIGNUPS_ALLOWED`设置为`true`，然后注册管理员账号（邮箱地址为标识符，无需实际邮箱验证）
- 管理员账号注册之后即可设置`SIGNUPS_ALLOWED`为`false`禁止注册，确保安全
- 若忘记管理员密码或者需要更高级别配置，可以访问`https://your.domain.com/admin`，输入`ADMIN_TOKEN`设定的值登录即可

## 参考
- [使用Docker安装Bitwarden的教程][1]

[1]: https://shuyeidc.com/wp/224325.html
