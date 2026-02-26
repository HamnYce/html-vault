FROM ruby:3.2.10-alpine3.23

RUN apk add --no-cache build-base

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle i

COPY models models
COPY views views
COPY public public 
COPY app.rb Rakefile ./

