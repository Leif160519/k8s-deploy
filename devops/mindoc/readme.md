## 前置条件
```
mkdir ./mindoc/calibre
cd ./mindoc/calibre
wget https://download.calibre-ebook.com/5.44.0/calibre-5.44.0-x86_64.txz
tar xJof calibre-5.44.0-x86_64.txz
find calibre-5.44.0-x86_64.txz -delete
```
> 参考：https://github.com/mindoc-org/mindoc/issues/807

## 使用方法
浏览器登录http://127.0.0.1:8181
初始账户：admin 密码：123456

## 参考
https://zhuanlan.zhihu.com/p/651736429?utm_id=0

## 注意
- 其他配置修改可以直接修改./mindoc/conf/app.conf文件，容器会自动加载配置

## 修改密码
在0.11 及以上版本支持通过命令行修改密码：
```
./mindoc_linux_amd64 password -account admin -password 123456
```
