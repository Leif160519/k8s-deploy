#!/bin/bash
TLS_PATH_KEY="STAR.github.icu.key"
TLS_PATH_CRT="STAR.github.icu.pem"
for NAMESPACE in `kubectl get ing -A |grep github |awk '{print $1}'|uniq |xargs `;
do 
    kubectl delete secret github-tls -n $NAMESPACE
    kubectl create secret tls github-tls --key ${TLS_PATH_KEY} --cert ${TLS_PATH_CRT} -n ${NAMESPACE} && echo "github-tls更新成功"
done
