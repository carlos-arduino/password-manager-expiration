FROM ruby:3.3.6

RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    npm

WORKDIR /var/www/password-manager-expiration

# RUN gem install rails

COPY Gemfile* ./

RUN bundle install

COPY . .
