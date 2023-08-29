## 运行报错
```
    State:          Waiting
      Reason:       CrashLoopBackOff
    Last State:     Terminated
      Reason:       Error
      Exit Code:    132
      Started:      Tue, 29 Aug 2023 13:55:36 +0800
      Finished:     Tue, 29 Aug 2023 13:55:36 +0800
    Ready:          False
```

退出码132，因为着cpu指令不支持，`mongo:5.0.3`需要AVX指令集支持，若是用类似J1900这种cpu，本身不支持AVX指令集的，就无法启动，需要降低mongo的版本，可以使用`mongo:4.4.9`，该版本不需要AVX指令集，参考：[Docker安装mongodb，退出代码132][1]

> 如何判断cpu支不支持AVX指令集:`lscpu | grep -i avx`

[1]: https://www.guojiangbo.com/2021/10/04/docker%E5%AE%89%E8%A3%85mongodb%EF%BC%8C%E9%80%80%E5%87%BA%E4%BB%A3%E7%A0%81132/
