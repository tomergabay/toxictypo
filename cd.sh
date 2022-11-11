#!/bin/bash


echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~deplying~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
#connect to the instance, cleanup the machine, extract the files from the .tar and execute the app
ssh ubuntu@$1 << EOF
docker rm -f /application
aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/c7o8u9c1
docker pull c7o8u9c1.dkr.ecr.us-east-1.amazonaws.com/toxicapp:${env.BUILD_NUMBER}
docker run --name application -p 8080:8080 toxicapp:${env.BUILD_NUMBER}
EOF
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~deplyed~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

