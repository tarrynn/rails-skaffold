FROM ruby:2.6.6-slim

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev libsqlite3-dev git curl

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs

RUN gem install bundler:2.2.6

RUN npm install --global yarn

RUN mkdir /rails
WORKDIR /rails

COPY Gemfile /rails/Gemfile
COPY Gemfile.lock /rails/Gemfile.lock

RUN bundle config set --local path 'vendor/cache' && bundle install

COPY package.json /rails/package.json
COPY yarn.lock /rails/yarn.lock

RUN yarn install --production=false --frozen-lockfile

# Copy the whole app
COPY . /rails

RUN bundle exec rake webpacker:compile

EXPOSE 3000/tcp

CMD ["/rails/bin/rails", "s", "-b", "0.0.0.0"]
