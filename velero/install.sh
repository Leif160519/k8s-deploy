#!/bin/bash
BUCKET=velero-k8s
REGION=minio

/usr/bin/velero install \
    --kubeconfig /root/.kube/config \
    --provider aws \
    --plugins velero/velero-plugin-for-aws:v1.8.1 \
    --bucket ${BUCKET} \
    --use-volume-snapshots=false \
    --use-node-agent \
    --uploader-type=restic \
    --namespace velero \
    --image=velero/velero:v1.12.1 \
    --backup-location-config region=$REGION,s3ForcePathStyle="true",s3Url=https://console.github.icu \
    --secret-file /opt/velero/cfg/credentials-velero
