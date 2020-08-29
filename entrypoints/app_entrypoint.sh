#!/bin/sh

gem install bundler -v 2.1.4
bin/bundle install

rm -f tmp/pids/server.pid
bin/rake db:create
bin/rails db:setup
echo Start migrations
bin/bundle exec rails db:migrate RAILS_ENV=development
echo Migrations done!

# only in dev evtrypoint
bin/bundle exec rails db:seed

bin/rails server --port 3000 --binding 0.0.0.0
