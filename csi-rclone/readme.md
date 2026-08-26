## 参数说明
- remote: 指定rclone使用的存储后端类型。对于S3兼容服务（含MinIO），固定设置为"s3"
- remotePath: 在 MinIO 存储桶内创建的路径前缀，用于隔离不同 PVC 的数据,此路径一定要是存在的，如果不存在请在minio底层存储中创建
- s3-provider: S3 服务提供商标识。设置为 "Minio" 可启用 MinIO 特有的兼容选项
- s3-endpoint: MinIO 服务的访问地址，必须包含协议头
- s3-access-key-id: MinIO 的 Access Key（访问密钥 ID）
- s3-secret-access-key: MinIO 的 Secret Key（私有密钥）。
- parameters: 可在此处覆盖 Secret 中的默认参数,但 Secret 中的值优先级更高
- pathPattern: pod数据存储的路径，默认就放在remotePath下，建议根据命名空间等信息进行隔离

> access key和secret key确保对remotePath有consuladmin或者readwrite权限!


## 参考
- [wunderio/csi-rclone][1]

[1]: https://github.com/wunderio/csi-rclone
