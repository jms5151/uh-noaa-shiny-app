#!/bin/bash
# Script to deploy.
set -e

if [ -z "$HOST" ]
then
    echo "\n>>> Error: HOST environment variable must be set."
    exit 1
fi
if [ -z "$DOCKER_PASSWORD" ]
then
    echo "\n>>> Error: DOCKER_PASSWORD environment variable must be set."
    exit 1
fi
if [ -z "$DOCKER_ID" ]
then
    echo "\n>>> Error: DOCKER_ID environment variable must be set."
    exit 1
fi
if [ -z "$DOCKER_STACK_NAME" ]
then
    echo "\n>>> Error: DOCKER_STACK_NAME environment variable must be set."
    exit 1
fi

echo -e "\n>>> Deploying Docker Stack $DOCKER_STACK_NAME to $HOST"
DEPLOY_DIR="/srv/deploy/$(date +%s)"

echo -e "\n>>> Creating deployment directory $DEPLOY_DIR"
chmod 400 infra/id_rsa
ssh -o StrictHostKeyChecking=no -i infra/id_rsa root@$HOST mkdir -p $DEPLOY_DIR

scp -o StrictHostKeyChecking=no -i infra/id_rsa \
    infra/docker-compose.prod.yml \
    root@$HOST:${DEPLOY_DIR}/docker-compose.prod.yml

echo -e "\n>>> Updating Docker Swarm stack $DOCKER_STACK_NAME"
ssh -o StrictHostKeyChecking=no -i infra/id_rsa root@$HOST /bin/bash << EOF
    set -e
    echo "Deploying new container"
    cd $DEPLOY_DIR
    echo "$DOCKER_PASSWORD" | docker login --username $DOCKER_ID --password-stdin
    rm -f /srv/socks/shiny.sock
    docker stack deploy --with-registry-auth --compose-file docker-compose.prod.yml $DOCKER_STACK_NAME
    docker service update --force coral_web
    echo "Pruning docker images"
    docker image prune -af
EOF

echo -e "\n>>> Deployment finished"
