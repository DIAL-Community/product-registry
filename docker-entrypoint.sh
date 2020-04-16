#!/bin/bash
set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

until PGPASSWORD=${POSTGRES_PASSWORD} psql -h ${POSTGRES_HOST}  -U ${POSTGRES_USER} -d ${POSTGRES_DB} -p ${POSTGRES_PORT}  -c '\q'; do
  sleep 2s
done

echo "Version: $(git rev-parse --short HEAD)" > public/version.txt

. ./setEnv.sh prod

rails db:run_if_no_db && rails db:create_db_with_public_data
rails db:migrate
rails db:seed
rails assets:precompile RAILS_ENV=production

service cron restart

rails server -e production
