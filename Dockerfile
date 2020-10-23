FROM ruby:2.6 AS build-web

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get update -qq && apt-get install -y cron git imagemagick build-essential libpq-dev nodejs logrotate cmake cloc
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
RUN apt-get update
RUN apt-get install -y postgresql-client-11

RUN mkdir /candidates
RUN git clone https://github.com/unicef/publicgoods-candidates.git /candidates

RUN mkdir /products
RUN git clone https://github.com/publicgoods/products.git /products

RUN mkdir /maturity-rubric
RUN git clone https://github.com/publicgoods/maturity-rubric.git /maturity-rubric

COPY cron-sync /etc/cron.d/cron-sync
RUN crontab /etc/cron.d/cron-sync

RUN mkdir /t4d
WORKDIR /t4d
COPY Gemfile /t4d/Gemfile
COPY Gemfile.lock /t4d/Gemfile.lock

ENV BUNDLER_VERSION 2.1.4
RUN gem install bundler && bundle install --jobs 4 --retry 5

COPY . /t4d
