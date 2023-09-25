## 使用方法：
### 1.初始化数据库
```
mysql -u root -h mysql.github.icu < 0.tables_xxl_job.sql
```

## 2.创建数据库用户
```
create user xxl_job_user identified by 'xxl_job_admin';
grant all privileges on xxl_job.* to xxl_job_user;
```

## 3.创建deployment，service和ingress
```
kubectl apply -f 1.deployment.yaml
kubectl apply -f 2.service.yaml
```

## 注意：
初始账号为`admin:123456`
