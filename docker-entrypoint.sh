#!/bin/bash
set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

rails db:run_if_no_db && rails db:create_db_with_public_data
rails assets:precompile RAILS_ENV=production

cron

rails server -e production
