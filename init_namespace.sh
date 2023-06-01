#!/bin/bash
TLS_PATH_KEY="STAR.github.icu.key"
TLS_PATH_CRT="STAR.github.icu.pem"
if [ $# -eq 0 ];then
    echo "请输入需要初始化的namespace,可同时输入多个命名空间,用空格分开"
    exit
else
    for NAMESPACE ;do
        kubectl get ns ${NAMESPACE}
        if [ $? -ne 0 ];then
            kubectl create ns ${NAMESPACE} && echo "${NAMESPACE}创建成功"
        fi

        kubectl get secret registry-auth -n ${NAMESPACE}
        if [ $? -ne 0 ];then
            kubectl create secret generic registry-auth -n ${NAMESPACE} --from-file=.dockerconfigjson=/root/.docker/config.json --type=kubernetes.io/dockerconfigjson && echo "registry-auth创建成功"
        fi

        kubectl get secret github-tls -n ${NAMESPACE}
        if [ $? -ne 0 ];then
            kubectl create secret tls github-tls --key ${TLS_PATH_KEY} --cert ${TLS_PATH_CRT} -n ${NAMESPACE} && echo "github-tls创建成功"
        fi

        if [ $? -ne 0 ];then
            echo "初始化${NAMESPACE}失败"
        else
            echo "初始化${NAMESPACE}成功"
        fi
    done
fi
