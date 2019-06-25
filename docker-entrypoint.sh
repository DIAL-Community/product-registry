#!/bin/bash
set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

rails db:create RAILS_ENV=production
rails db:migrate RAILS_ENV=production
rails db:seed RAILS_ENV=production
rails assets:precompile RAILS_ENV=production

cron

rails server -e production
