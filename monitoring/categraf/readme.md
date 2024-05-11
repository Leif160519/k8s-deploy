## 准备工作
### 1.创建configmap
```
kubectl create configmap -n monitoring categraf-config \
    --from-file etc-categraf/config.toml

kubectl create configmap -n monitoring input-config \
    --from-file etc-categraf/input.vsphere/vsphere.toml
```

## 部署
```
kubectl apply -f .
```

## 注意
由于categraf成功读取`vsphere.toml`等插件的前提是确保`input.vsphere`文件夹在pod中的形式是以真实文件夹存在，而非configmap默认挂载的软连接，所以需要创建两个configmap，一个是config.toml，一个是input文件夹下的toml文件（两者目录不一样），所以下方的写法会导致无法读取`vsphere.toml`
```
        volumeMounts:
        - name: localtime
          mountPath: /etc/localtime
        - name: categraf-config
          mountPath: /etc/categraf/conf
      volumes:
      - name: localtime
        hostPath:
          path: /etc/localtime
          type: ""
      - name: categraf-config
        configMap:
          defaultMode: 420
          name: categraf-config
          items:
          - key: config.toml
            path: config.toml
          - key: vsphere.toml
            path: input.vsphere/vsphere.toml
```
