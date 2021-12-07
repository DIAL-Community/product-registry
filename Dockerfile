FROM ruby:2.6 AS build-web

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get update -qq && apt-get install -y cron git imagemagick build-essential libpq-dev nodejs logrotate cmake cloc
RUN wget --quiet --no-check-certificate -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - 
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
RUN apt-get update
RUN apt-get install -y postgresql-client-12

RUN mkdir /candidates
RUN git clone https://github.com/unicef/publicgoods-candidates.git /candidates

RUN mkdir /products
RUN git clone https://github.com/publicgoods/products.git /products

RUN mkdir /maturity-rubric
RUN git clone https://github.com/publicgoods/maturity-rubric.git /maturity-rubric

COPY cron-sync /etc/cron.d/cron-sync
RUN crontab /etc/cron.d/cron-sync

WORKDIR /tmp
ENV BUNDLER_VERSION 2.1.4
COPY Gemfile /tmp/Gemfile
COPY Gemfile.lock /tmp/Gemfile.lock

RUN gem install bundler && bundle install --jobs 10 --retry 5

RUN mkdir /t4d
WORKDIR /t4d

COPY . /t4d


FROM ruby:2.6 AS build-web2

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get update -qq && apt-get install -y cron git imagemagick build-essential libpq-dev nodejs logrotate cmake cloc
RUN wget --quiet --no-check-certificate -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - 
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
RUN apt-get update
RUN apt-get install -y postgresql-client-12

RUN mkdir /candidates
RUN git clone https://github.com/unicef/publicgoods-candidates.git /candidates

RUN mkdir /products
RUN git clone https://github.com/publicgoods/products.git /products

RUN mkdir /maturity-rubric
RUN git clone https://github.com/publicgoods/maturity-rubric.git /maturity-rubric

WORKDIR /tmp
ENV BUNDLER_VERSION 2.1.4
COPY Gemfile /tmp/Gemfile
COPY Gemfile.lock /tmp/Gemfile.lock

RUN gem install bundler && bundle install --jobs 10 --retry 5

RUN mkdir /t4d
WORKDIR /t4d

COPY . /t4d
