#!/bin/sh

gem install bundler -v 2.1.4
bin/bundle install

rm -f tmp/pids/server.pid
bin/bundle exec rake db:create
echo Start migrations
bin/bundle exec rails db:migrate RAILS_ENV=development
echo Migrations done!

# only in dev evtrypoint
bin/bundle exec sidekiq
