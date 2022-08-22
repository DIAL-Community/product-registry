#!/bin/bash

# start cron
service cron start

# start nginx
echo "starting nginx"
nginx -g 'daemon off;'