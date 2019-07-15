#!/bin/bash
set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

until PGPASSWORD=Password!1 psql -h "postgres" -U "registry" -d "registry_test" -c '\q'; do
  sleep 2s
done

rails db:create_db_with_public_data
rails db:migrate
rails assets:precompile RAILS_ENV=test

cron

rails test -e test
