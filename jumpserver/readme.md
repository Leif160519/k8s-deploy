## jumpserver安装
```
kubectl apply -f 0.pvc-mfs.yaml
kubectl apply -f 1.namespace.yaml
·
·
·
kubectl apply -f 9.jms-web.yaml
```
注意：core部署时需要初始化数据库，时间大概为5分钟，故去掉了健康检查

## 设置koko 2222端口的tcp转发
- 1.kubectp patch svc nginx -n devops --patch-file=11.patch.nginx.lb.yaml
- 2.在nginx的pvc里新建一个tcp文件夹，把12.jms-koko.tcp文件放进去
- 3.刷新nginx配置

## 创建jumpserver访问k8s集群的访问token
### 方法一：k8s版本低于2.24,自动生成token
```
kubectl apply -f 10.jms-token.yaml
kubectl get sa -n jms | grep admin-user
kubectl describe secrets admin-user-token-xxx -n jms | grep token
或者
kubectl get secret $(kubectl -n jms get secret | grep admin-user | awk 'NR==1{print $1}') -n jms -o go-template='{{.data.token}}' |base64 -d
```

### 方法二：k8s版本高于2.24，手动生成token
集群版本为1.24以上，则创建serviceaccount资源的时候，集群不会自动创建对应的secret token,这时需要手动创建token
```
kubectl apply -f 10.jms-token.yaml
kubectl get sa -n jms | grep admin-user
kubectl create token admin-user -n jms（执行完会自动输出token）
```
注意：
- 1.创建serviceaccount的角色权限必须为cluster-admin，否则访问某些资源会没有权限
- 2.创建token的命令可以重复执行，每次执行会生成不同的token，且旧token不会过期，可以用如下命令验证：
```
kubectl get node --server=https://xxx.8443 --token=xxx
```

## 方法三：使用其他命名空间下的token
- 1.查找类型为`service-account-token`类型的`secret`
```
$ kubectl get secrets -A | grep service-account-token
cattle-fleet-system                      fleet-controller-bootstrap-token                           kubernetes.io/service-account-token   3      33d
cattle-impersonation-system              cattle-impersonation-u-b4qkhsnliz-token-fjmlq              kubernetes.io/service-account-token   3      33d
cattle-impersonation-system              cattle-impersonation-u-mo773yttt4-token-xkvx9              kubernetes.io/service-account-token   3      33d
cattle-system                            git-webhook-api-service-token-wgbhq                        kubernetes.io/service-account-token   3      33d
cluster-fleet-local-local-1a3d67d0a899   request-7f27k-c04ad872-c513-40fc-b4a3-da418489ce5e-token   kubernetes.io/service-account-token   3      33d
```
- 2.我们选用第一个token(以rancher的secret为例--确保选择的token对应的serviceaccount的角色权限是cluster-admin，否则权限不足无法登录集群):
```
$ kubectl get secret fleet-controller-bootstrap-token -n cattle-fleet-system -o  yaml | grep token

  token: ZXlKaGJHY2lPaUpTVXpJMU5pSXNJbXRwWkNJNklqQmhkMDQyTlZnd2FWSnNabGxMWVc4eVpuVjNXalppVVhGWGVraHJhRTlTU1dSbk9EbGZWVTlQWVRnaWZRLmV5SnBjM01pT2lKcmRXSmxjbTVsZEdWekwzTmxjblpwWTJWaFkyTnZkVzUwSWl3aWEzVmlaWEp1WlhSbGN5NXBieTl6WlhKMmFXTmxZV05qYjNWdWRDOXVZVzFsYzNCaFkyVWlPaUpqWVhSMGJHVXRabXhsWlhRdGMzbHpkR1Z0SWl3aWEzVmlaWEp1WlhSbGN5NXBieTl6WlhKMmFXTmxZV05qYjNWdWRDOXpaV055WlhRdWJtRnRaU0k2SW1ac1pXVjBMV052Ym5SeWIyeHNaWEl0WW05dmRITjBjbUZ3TFhSdmEyVnVJaXdpYTNWaVpYSnVaWFJsY3k1cGJ5OXpaWEoyYVdObFlXTmpiM1Z1ZEM5elpYSjJhV05sTFdGalkyOTFiblF1Ym1GdFpTSTZJbVpzWldWMExXTnZiblJ5YjJ4c1pYSXRZbTl2ZEhOMGNtRndJaXdpYTNWaVpYSnVaWFJsY3k1cGJ5OXpaWEoyYVdObFlXTmpiM1Z1ZEM5elpYSjJhV05sTFdGalkyOTFiblF1ZFdsa0lqb2lNbUZsWTJReU9XTXRZVGc0T1MwME5XWm1MV0k0TVRNdE9EQXpZbVV6TWpobE5qa3lJaXdpYzNWaUlqb2ljM2x6ZEdWdE9uTmxjblpwWTJWaFkyTnZkVzUwT21OaGRIUnNaUzFtYkdWbGRDMXplWE4wWlcwNlpteGxaWFF0WTI5dWRISnZiR3hsY2kxaWIyOTBjM1J5WVhBaWZRLlR1RmJob0JKcFY4RVRUd1czTndzbmFBdVpQSjdISTlRSmNNX2tiWkFuRnRxYTVxX0x3VzJxNFNtc3NhQmlPSUNSUFd2STJRaFFwaXNNRGJMaXF5c1ZkaFFTekFjUG93UHdWQ0lwTm5YeHZyVUZSV2xkZTBPWmF5cUhqb29YcFRzVm1YenNDSThnWWYwbFN4Vi1RUHJkdzdaOUtnNnZBeXJELXpiRXRCUWh1T3NBa1lXMmlENGV5RlJiMmk2Yk9WV2NMSVd4SUlFM0lMR0ZQX2pweDN2ZmpTNEhlb0UyME5mVzBKWVBqR0tuTmZ1aHZMdWtaMVdtdHc2ak9yckoyaHJDQVhqcmxRbHJYa2VQYUxPMmp3a1BGVURlOFNCUEQ4V05CZEZndU1wcng4cTN0SmFiLV9saVo5TDVBVGxZNmhoaW9lTmtEdWpWUkdoX05JVWkwUXBCUQ==
```

- 2.将token后面的内容用base64解码即可获得可以登陆k8s集群的token了
```
$ echo "ZXlKaGJHY2lPaUpTVXpJMU5pSXNJbXRwWkNJNklqQmhkMDQyTlZnd2FWSnNabGxMWVc4eVpuVjNXalppVVhGWGVraHJhRTlTU1dSbk9EbGZWVTlQWVRnaWZRLmV5SnBjM01pT2lKcmRXSmxjbTVsZEdWekwzTmxjblpwWTJWaFkyTnZkVzUwSWl3aWEzVmlaWEp1WlhSbGN5NXBieTl6WlhKMmFXTmxZV05qYjNWdWRDOXVZVzFsYzNCaFkyVWlPaUpqWVhSMGJHVXRabXhsWlhRdGMzbHpkR1Z0SWl3aWEzVmlaWEp1WlhSbGN5NXBieTl6WlhKMmFXTmxZV05qYjNWdWRDOXpaV055WlhRdWJtRnRaU0k2SW1ac1pXVjBMV052Ym5SeWIyeHNaWEl0WW05dmRITjBjbUZ3TFhSdmEyVnVJaXdpYTNWaVpYSnVaWFJsY3k1cGJ5OXpaWEoyYVdObFlXTmpiM1Z1ZEM5elpYSjJhV05sTFdGalkyOTFiblF1Ym1GdFpTSTZJbVpzWldWMExXTnZiblJ5YjJ4c1pYSXRZbTl2ZEhOMGNtRndJaXdpYTNWaVpYSnVaWFJsY3k1cGJ5OXpaWEoyYVdObFlXTmpiM1Z1ZEM5elpYSjJhV05sTFdGalkyOTFiblF1ZFdsa0lqb2lNbUZsWTJReU9XTXRZVGc0T1MwME5XWm1MV0k0TVRNdE9EQXpZbVV6TWpobE5qa3lJaXdpYzNWaUlqb2ljM2x6ZEdWdE9uTmxjblpwWTJWaFkyTnZkVzUwT21OaGRIUnNaUzFtYkdWbGRDMXplWE4wWlcwNlpteGxaWFF0WTI5dWRISnZiR3hsY2kxaWIyOTBjM1J5WVhBaWZRLlR1RmJob0JKcFY4RVRUd1czTndzbmFBdVpQSjdISTlRSmNNX2tiWkFuRnRxYTVxX0x3VzJxNFNtc3NhQmlPSUNSUFd2STJRaFFwaXNNRGJMaXF5c1ZkaFFTekFjUG93UHdWQ0lwTm5YeHZyVUZSV2xkZTBPWmF5cUhqb29YcFRzVm1YenNDSThnWWYwbFN4Vi1RUHJkdzdaOUtnNnZBeXJELXpiRXRCUWh1T3NBa1lXMmlENGV5RlJiMmk2Yk9WV2NMSVd4SUlFM0lMR0ZQX2pweDN2ZmpTNEhlb0UyME5mVzBKWVBqR0tuTmZ1aHZMdWtaMVdtdHc2ak9yckoyaHJDQVhqcmxRbHJYa2VQYUxPMmp3a1BGVURlOFNCUEQ4V05CZEZndU1wcng4cTN0SmFiLV9saVo5TDVBVGxZNmhoaW9lTmtEdWpWUkdoX05JVWkwUXBCUQ==" | base64 -d

eyJhbGciOiJSUzI1NiIsImtpZCI6IjBhd042NVgwaVJsZllLYW8yZnV3WjZiUXFXekhraE9SSWRnODlfVU9PYTgifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJjYXR0bGUtZmxlZXQtc3lzdGVtIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6ImZsZWV0LWNvbnRyb2xsZXItYm9vdHN0cmFwLXRva2VuIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6ImZsZWV0LWNvbnRyb2xsZXItYm9vdHN0cmFwIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiMmFlY2QyOWMtYTg4OS00NWZmLWI4MTMtODAzYmUzMjhlNjkyIiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50OmNhdHRsZS1mbGVldC1zeXN0ZW06ZmxlZXQtY29udHJvbGxlci1ib290c3RyYXAifQ.TuFbhoBJpV8ETTwW3NwsnaAuZPJ7HI9QJcM_kbZAnFtqa5q_LwW2q4SmssaBiOICRPWvI2QhQpisMDbLiqysVdhQSzAcPowPwVCIpNnXxvrUFRWlde0OZayqHjooXpTsVmXzsCI8gYf0lSxV-QPrdw7Z9Kg6vAyrD-zbEtBQhuOsAkYW2iD4eyFRb2i6bOVWcLIWxIIE3ILGFP_jpx3vfjS4HeoE20NfW0JYPjGKnNfuhvLukZ1Wmtw6jOrrJ2hrCAXjrlQlrXkePaLO2jwkPFUDe8SBPD8WNBdFguMprx8q3tJab-_liZ9L5ATlY6hhioeNkDujVRGh_NIUi0QpBQ
```

或者直接用以下命令获得token：
```
kubectl describe secret fleet-controller-bootstrap-token -n cattle-fleet-system  | grep token
```

## token的使用
将上述token填写到jumperver的资产管理->统用户->创建系统用户，类型选择kubernetes，将token填写进去，之后将k8s应用与系统用户绑定即可

## jms_all
若不想逐个部署jumpserver的各个组件，可以使用jms_all文件夹里的配置文件，使用jms_all镜像进行统一部署

注意：jms_all的最后一个版本为v2.28.7，且已经停止维护
