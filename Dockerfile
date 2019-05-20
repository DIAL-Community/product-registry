FROM ruby:2.6.3 AS build-web

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir /t4d
WORKDIR /t4d
COPY Gemfile /t4d/Gemfile
COPY Gemfile.lock /t4d/Gemfile.lock

ENV BUNDLER_VERSION 2.0.1
RUN gem install bundler && bundle install --jobs 20 --retry 5

COPY . /t4d

FROM ruby:2.6.3 AS build-cron
RUN apt-get update && apt-get install -y cron git build-essential libpq-dev nodejs

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
