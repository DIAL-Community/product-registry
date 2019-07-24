#!/bin/bash

read -p "Please enter new version number: " version_number
export T4D_VERSION=$version_number
docker-compose -f ../../docker-compose.yml build
docker-compose -f ../../docker-compose.yml push
docker service update --image localhost:5000/t4d-product-backlog:$version_number --update-delay 1m t4d-app_web