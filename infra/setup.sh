#!/bin/bash
set -e

HOST="66.228.47.179"

echo -e "\n>>> Setting up $HOST"

echo -e "\n>>> Uploading infra files to $HOST"
ssh root@$HOST mkdir -p /srv/
ssh root@$HOST mkdir -p /srv/deploy/
ssh root@$HOST rm -rf /srv/infra/
scp -r infra/ root@$HOST:/srv/infra/

echo -e "\n>>> Updating apt sources on $HOST"
ssh root@$HOST apt-get update -qq

echo -e "\n>>> Setting up NGINX on $HOST"
ssh root@$HOST /srv/infra/setup-nginx.sh

echo -e "\n>>> Setting up Docker on $HOST"
ssh root@$HOST /srv/infra/setup-docker.sh

echo -e "\n>>> Hardening server on $HOST"
ssh root@$HOST /srv/infra/setup-secure.sh

echo -e "\n>>> Finished setting up $HOST"
