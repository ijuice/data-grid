FROM ruby:2.3.3
ENV TERM=xterm
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs rsync
RUN mkdir /myapp
WORKDIR /myapp
ADD Gemfile /myapp/Gemfile
ADD Gemfile.lock /myapp/Gemfile.lock
ADD grid.gemspec /myapp/grid.gemspec
RUN bundle install
ADD . /myapp