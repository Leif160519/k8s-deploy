## 注意
- 由于我的cpu不支持kvm加速，所以pod文件中关闭了kvm功能，如果支持的话，还是建议将这个参数去掉，否则windows运行会很慢
```
INFO: Your CPU does not support KVM extensions
KVM acceleration can NOT be used
```

## 访问
浏览器访问http://<任意k8s节点ip>:30006 打开vnc界面
默认内置账户名：Docker，密码为空

## 参考
- [dockur/windows][1]
- [[Question]: How setting KVM=N with docker compose? #479][2]

[1]: https://github.com/dockur/windows
[2]: https://github.com/dockur/windows/issues/479
