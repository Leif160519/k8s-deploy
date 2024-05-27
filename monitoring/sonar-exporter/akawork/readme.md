## 参考
- [Sonar-Exporter][1]
- [dashboard-Sonar Exporter][2]


## Step 1: Download project
```
git clone https://github.com/akawork/Sonar-Exporter.git
```

## Step 1:Build image
```
cd Sonar-Exporter
docker build -t sonar_exporter .
```

## Step 3: Run
```
kubectl apply -f .
```


[1]: https://github.com/akawork/Sonar-Exporter
[2]: https://grafana.com/grafana/dashboards/10763-sonar-exporter/
