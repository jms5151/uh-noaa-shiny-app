#!/bin/bash
# Rebuild from scratch and push to DockerHub
if [ -z "$DOCKER_PASSWORD" ]
then
    echo -e "\nDOCKER_PASSWORD envar is required - exiting"
    exit 1
fi   
if [ -z "$DOCKER_USERNAME" ]
then
    echo -e "\nDOCKER_USERNAME envar is required - exiting"
    exit 1
fi   
export DOCKER_BUILDKIT=1 

docker build \
    --tag jamiecaldwell/uh-crw:latest \
    --build-arg BUILDKIT_INLINE_CACHE=1 \
    --no-cache \
    .

docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
docker push jamiecaldwell/uh-crw:latest