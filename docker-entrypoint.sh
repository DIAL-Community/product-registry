#!/bin/bash
set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

until PGPASSWORD=Password!1 psql -h "postgres" -U "registry" -d "registry_production" -c '\q'; do
  sleep 2s
done

rails db:run_if_no_db && rails db:create_db_with_public_data
rails db:migrate
rails assets:precompile RAILS_ENV=production

cron

rails server -e production
