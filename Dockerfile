FROM ruby:2.6.3

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir /t4d
WORKDIR /t4d
COPY Gemfile /t4d/Gemfile
COPY Gemfile.lock /t4d/Gemfile.lock

ENV BUNDLER_VERSION 2.0.1
RUN gem install bundler && bundle install --jobs 20 --retry 5

COPY . /t4d