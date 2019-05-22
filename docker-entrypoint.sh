#!/bin/bash
set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

rails db:create
rails db:migrate
rails db:seed

cron

rails server
