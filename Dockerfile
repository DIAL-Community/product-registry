FROM ruby:2.6.3 AS build-web

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update -qq && apt-get install -y cron git build-essential libpq-dev nodejs mpack
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
RUN apt-get update
RUN apt-get install -y postgresql-client-11

RUN mkdir /candidates
RUN git clone https://github.com/unicef/publicgoods-candidates.git /candidates

COPY cron-sync /etc/cron.d/cron-sync
RUN crontab /etc/cron.d/cron-sync

RUN mkdir /t4d
WORKDIR /t4d
COPY Gemfile /t4d/Gemfile
COPY Gemfile.lock /t4d/Gemfile.lock

ENV BUNDLER_VERSION 2.0.1
RUN gem install bundler && bundle install --jobs 20 --retry 5

COPY . /t4d
