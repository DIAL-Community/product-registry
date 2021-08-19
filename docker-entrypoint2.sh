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

rails assets:precompile RAILS_ENV=production

rails server -e production
