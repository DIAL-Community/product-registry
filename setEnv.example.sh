#!/bin/bash

if [ $# -eq 0 ]
then
    read -p "Which environment (DEV, test, prod): " user_env
    user_env="${user_env:-prod}"
else
    user_env=$1
fi

if [ "${user_env:0:1}" == "d" ] || [ "${user_env:0:1}" == "D" ]; then
  export SECRET_KEY_BASE=<devise secret key>
  export DATABASE_NAME=registry_development
  export DATABASE_USER=registry
  export DATABASE_PASSWORD=<DB password>
  export DATABASE_HOST=localhost
  export DATABASE_PORT=5432
  export TEST_DATABASE_NAME=registry_test
  export TEST_DATABASE_USER=registry
  export TEST_DATABASE_PASSWORD=<DB password>
  export ESRI_CLIENT_ID=<esri client id>
  export ESRI_CLIENT_SECRET=<esri secret>
  export GOOGLE_TRACKER=<google tracker id>
  export GOOGLE_API_KEY=<google map api key>
  export JENKINS_URL=<jenkins host url>
  export JENKINS_USER=<jenkins user>
  export JENKINS_PASSWORD=<jenkins password>
  export MAILGUN_API_KEY=<mailgun api key>
  export MAILGUN_DOMAIN=<mailgun domain>
  export CAPTCHA_SITE_KEY=<your captcha site key>
  export CAPTCHA_SECRET_KEY=<your captcha secret key>
  export GITHUB_USERNAME=<your github username>
  export GITHUB_PERSONAL_TOKEN=<your github personal token>
  export REDIS_HOST=<your redis host>
  export REDIS_PORT=<your redis port>
fi
if [ "${user_env:0:1}" == "t" ] || [ "${user_env:0:1}" == "T" ]; then
  export SECRET_KEY_BASE=<devise secret key>
  export DATABASE_NAME=registry_development
  export DATABASE_USER=registry
  export DATABASE_PASSWORD=<DB password>
  export DATABASE_HOST=localhost
  export DATABASE_PORT=5432
  export TEST_DATABASE_NAME=registry_test
  export TEST_DATABASE_USER=registry
  export TEST_DATABASE_PASSWORD=<DB password>
  export ESRI_CLIENT_ID=<esri client id>
  export ESRI_CLIENT_SECRET=<esri secret>
  export GOOGLE_TRACKER=<google tracker id>
  export GOOGLE_API_KEY=<google map api key>
  export JENKINS_URL=<jenkins host url>
  export JENKINS_USER=<jenkins user>
  export JENKINS_PASSWORD=<jenkins password>
  export MAILGUN_API_KEY=<mailgun api key>
  export MAILGUN_DOMAIN=<mailgun domain>
  export CAPTCHA_SITE_KEY=<your captcha site key>
  export CAPTCHA_SECRET_KEY=<your captcha secret key>
  export GITHUB_USERNAME=<your github username>
  export GITHUB_PERSONAL_TOKEN=<your github personal token>
  export REDIS_HOST=<your redis host>
  export REDIS_PORT=<your redis port>
fi
if [ "${user_env:0:1}" == "p" ] || [ "${user_env:0:1}" == "P" ]; then
  export SECRET_KEY_BASE=<devise secret key>
  export DATABASE_NAME=registry_development
  export DATABASE_USER=registry
  export DATABASE_PASSWORD=<DB password>
  export DATABASE_HOST=localhost
  export DATABASE_PORT=5432
  export TEST_DATABASE_NAME=registry_test
  export TEST_DATABASE_USER=registry
  export TEST_DATABASE_PASSWORD=<DB password>
  export ESRI_CLIENT_ID=<esri client id>
  export ESRI_CLIENT_SECRET=<esri secret>
  export GOOGLE_TRACKER=<google tracker id>
  export GOOGLE_API_KEY=<google map api key>
  export JENKINS_URL=<jenkins host url>
  export JENKINS_USER=<jenkins user>
  export JENKINS_PASSWORD=<jenkins password>
  export MAILGUN_API_KEY=<mailgun api key>
  export MAILGUN_DOMAIN=<mailgun domain>
  export CAPTCHA_SITE_KEY=<your captcha site key>
  export CAPTCHA_SECRET_KEY=<your captcha secret key>
  export GITHUB_USERNAME=<your github username>
  export GITHUB_PERSONAL_TOKEN=<your github personal token>
  export REDIS_HOST=<your redis host>
  export REDIS_PORT=<your redis port>
fi
