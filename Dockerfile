FROM ruby:3.3.4

RUN apt-get update -yqq && apt-get install -yqq build-essential libpq-dev nodejs vim
COPY Gemfile* /usr/src/app/

WORKDIR /usr/src/app

RUN bundle install

ADD . /usr/src/app/