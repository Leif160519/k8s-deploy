#!/bin/bash
src_image=$1
docker pull ${src_image}
image=`echo ${src_image} | awk -F / '{print $NF}'`
dest_image=docker.github.icu/${image}
docker tag ${src_image} ${dest_image}
docker login --username=admin --password=admin docker.github.icu
docker push ${dest_image}
echo -e "\ndocker pull ${dest_image}"
