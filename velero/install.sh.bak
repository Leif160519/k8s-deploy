#!/bin/bash
BUCKET=velero
REGION=minio

/usr/bin/velero install \
    --provider aws \
    --plugins velero/velero-plugin-for-aws:v1.4.0 \
    --bucket ${BUCKET} \
    --backup-location-config region=$REGION,s3ForcePathStyle="true",s3Url=https://console.github.icu \
    --snapshot-location-config region=$REGION,s3ForcePathStyle="true",s3Url=https://console.github.icu \
    --secret-file /opt/velero/cfg/credentials-velero
