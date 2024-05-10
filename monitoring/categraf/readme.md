## 准备工作
### 1.创建configmap
```
kubectl create configmap -n monitoring categraf-config \
    --from-file etc-categraf/config.toml \
    --from-file etc-categraf/input.cpu/cpu.toml \
    --from-file etc-categraf/input.disk/disk.toml \
    --from-file etc-categraf/input.diskio/diskio.toml \
    --from-file etc-categraf/input.kernel/kernel.toml \
    --from-file etc-categraf/input.mem/mem.toml \
    --from-file etc-categraf/input.net/net.toml \
    --from-file etc-categraf/input.netstat/netstat.toml \
    --from-file etc-categraf/input.processes/processes.toml \
    --from-file etc-categraf/input.prometheus/prometheus.toml \
    --from-file etc-categraf/input.system/system.toml \
    --from-file etc-categraf/input.vsphere/vsphere.toml
```

## 部署
```
kubectl apply -f .
```
