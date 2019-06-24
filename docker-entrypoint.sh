#!/bin/bash
set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

rails db:create RAILS_ENV=production
rails db:migrate RAILS_ENV=production
rails db:seed RAILS_ENV=production
rails assets:precompile RAILS_ENV=production
cp app/assets/javascripts/countries.json public/assets
cp app/assets/images/marker.png public/assets

cron

rails server -e production
