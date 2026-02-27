FROM ruby:3.2.10-alpine3.23

RUN apk add --no-cache build-base

WORKDIR /app

RUN touch db.sqlite3

COPY Gemfile Gemfile.lock Rakefile ./

RUN bundle i

COPY db db
COPY models models
COPY views views
COPY public public 
COPY app.rb .

