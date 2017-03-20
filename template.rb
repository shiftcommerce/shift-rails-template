gem 'jsonapi-resources', '0.9.0.beta3'
gem 'sidekiq', '4.2.9'

gem_group :development do
  gem 'reek', '~> 4.5'
  gem 'foreman', '~> 0.83', '>= 0.83'
end

gem_group :development, :test do
  gem 'rspec-rails', '~> 3.5'
end

gem_group :test do
  gem 'factory_girl_rails', '~> 4.7'
  gem 'faker', '~> 1.6'
  gem 'json_api_client', '~> 1.4'
end

# remove the database config file
run 'rm config/database.yml'

# empty the existing bin scripts
run 'rm -r bin'

file 'bin/boot', <<-CODE
#!/bin/bash
# ensure docker-machine won't be used
unset ${!DOCKER_*}
# spin up our image
docker-compose up --build
CODE

file 'bin/bundle', <<-CODE
#!/bin/bash
RAILS_ENV=${RAILS_ENV:-development} ./bin/run bundle $@
CODE

file 'bin/rails', <<-CODE
#!/bin/bash
RAILS_ENV=${RAILS_ENV:-development} ./bin/run ./bin/docker/rails $@
CODE

file 'bin/rake', <<-CODE
#!/bin/bash
RAILS_ENV=${RAILS_ENV:-development} ./bin/run ./bin/docker/rake $@
CODE

file 'bin/rspec', <<-CODE
#!/bin/bash
RAILS_ENV=${RAILS_ENV:-test} ./bin/run bundle exec rspec $@
CODE

file 'bin/run', <<-CODE
#!/bin/bash
docker-compose run --rm -e RAILS_ENV=${RAILS_ENV:-development} web $@
CODE

file 'bin/docker/rails', <<-CODE
#!/usr/local/bin/ruby
APP_PATH = File.expand_path('../../config/application', __dir__)
require_relative '../../config/boot'
require 'rails/commands'
CODE

file 'bin/docker/rake', <<-CODE
#!/usr/local/bin/ruby
require_relative '../../config/boot'
require 'rake'
Rake.application.run
CODE

file 'bin/docker/rspec_with_setup', <<-CODE
#!/bin/bash
./bin/docker/rake db:migrate
bundle exec rspec
CODE

file 'bin/docker/ruby_entrypoint', <<-CODE
#!/bin/bash
bundle check || {
  echo "Installing gems..."
  {
    bundle install --jobs 4 --retry 5 --quiet && echo "Installed gems."
  } || {
    echo "Gem installation failed."
    exit 1
  }
}

# remove any old PIDs
rm -f "tmp/pids/*"

exec "$@"
CODE

file 'bin/docker/yarn_entrypoint', <<-CODE
#!/bin/bash
yarn check || {
  echo "Installing Yarn packages..."
  {
    yarn install >/dev/null 2>&1 && echo "Installed Yarn packages."
  } || {
    echo "Yarn installation failed."
    exit 1
  }
}

exec "$@"
CODE

# make all scripts executable
run 'chmod +x bin/docker/* bin/*'

file '.dockerignore', <<-CODE
.git*
log/*
tmp/*
Dockerfile
docker-compose.yml
README.md
CODE

file 'docker-compose.yml', <<-CODE
version: '2'

services:
  web:
    build: .
    command: bundle exec foreman start -f ./Procfile.dev -p 3000
    entrypoint: ./bin/docker/ruby_entrypoint
    volumes:
      - .:/app
      - rubygems_cache:/rubygems
    ports:
      - '3000:3000'
    environment:
      GEM_HOME: '/rubygems'
      BUNDLE_PATH: '/rubygems'
      DATABASE_URL: 'postgres://postgres:@postgres:5432'
      REDIS_URL: 'redis://redis:6379'
    depends_on:
      - postgres
      - redis
    # needed for Codeship Pro:
    links:
      - postgres
      - redis

  yarn:
    build: .
    command: yarn run webpack --watch
    entrypoint: ./bin/docker/yarn_entrypoint
    volumes:
      - .:/app
      - yarn_cache:/app/node_modules

  postgres:
    image: postgres:9.6
    ports:
      - '5432'
    volumes:
      - postgres_data:/var/lib/postgresql

  redis:
    image: redis:3.2
    ports:
      - '6379'

volumes:
  postgres_data:
  rubygems_cache:
  yarn_cache:
CODE

file 'app.json', <<-CODE
{
  "name": "...",
  "description": "...",
  "keywords": [
    "rails",
    "sidekiq"
  ],
  "website": "https://...",
  "repository": "https://github.com/<username>/<repo>",
  "logo": "https://raw.githubusercontent.com/<username>/<repo>/master/docs/logo.png",
  "scripts": {
    "postdeploy": "bundle exec rake db:schema:load"
  },
  "env": {
    "WEB_CONCURRENCY": {
      "description": "The number of Puma web processes.",
      "value": "2"
    },
    "RAILS_MAX_THREADS": {
      "description": "The number of web threads.",
      "value": "5"
    },
    "SIDEKIQ_THREADS": {
      "description": "The number of concurrent Sidekiq threads.",
      "value": "5"
    }
  },
  "formation": {
    "web": {
      "quantity": 1,
      "size": "hobby"
    },
    "worker": {
      "quantity": 1,
      "size": "hobby"
    }
  },
  "image": "heroku/ruby",
  "buildpacks": [
    {
      "url": "heroku/nodejs"
    },
    {
      "url": "heroku/ruby"
    }
  ],
  "addons": [
    {
      "plan": "heroku-redis"
    },
    {
      "plan": "heroku-postgresql",
      "options": {
        "version": "9.6"
      }
    }
  ]
}
CODE

file 'config/puma.rb', <<-CODE
# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers a minimum and maximum.
# Default is 5
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }.to_i
threads threads_count, threads_count

# Specifies the `port` that Puma will listen on to receive requests, default is 3000.
port ENV.fetch("PORT") { 3000 }

# Specifies the `environment` that Puma will run in.
environment ENV.fetch("RAILS_ENV") { "development" }

# Specifies the number of `workers` to boot in clustered mode.
workers ENV.fetch("WEB_CONCURRENCY") { 2 }

preload_app!

on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end

plugin :tmp_restart
CODE

file 'Dockerfile', <<-CODE
FROM ruby:2.4-slim
LABEL maintainer "ryan@ryantownsend.co.uk"

# Install essentials and cURL
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  build-essential \
  curl

# Add the NodeJS source
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash -

# Add the Yarn source
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Install basic packages
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  git \
  libpq-dev \
  nodejs \
  yarn

# Install yarn
RUN npm install yarn

# Configure the main working directory
ENV app /app
RUN mkdir $app
WORKDIR $app

# Set the where to install gems
ENV GEM_HOME /rubygems
ENV BUNDLE_PATH /rubygems

# Link the whole application up
ADD . $app

# Ensure our Ruby gems / Yarn packages are installed when running commands
ENTRYPOINT ./bin/docker/ruby_entrypoint ./bin/docker/yarn_entrypoint $0 $@
CODE

file 'Procfile.dev', <<-CODE
web: ./bin/docker/rails s -b 0.0.0.0
worker: bundle exec sidekiq -c 4
CODE

file 'codeship-steps.yml', <<-CODE
- name: rspec
  service: web
  command: ./bin/docker/rspec_with_setup
CODE

file '.codeclimate.yml', <<-CODE
engines:
  brakeman:
    enabled: true
  bundler-audit:
    enabled: true
  duplication:
    enabled: true
    config:
      languages:
      - ruby
  fixme:
    enabled: true
  rubocop:
    enabled: true
  reek:
    enabled: true
ratings:
  paths:
  - Gemfile.lock
  - "**.erb"
  - "**.rb"
exclude_paths:
- config/
- db/
- spec/
- test/
- bin/
CODE

file '.reek', <<-CODE
---

IrresponsibleModule:
  enabled: false

LongParameterList:
  enabled: true
  exclude:
  - initialize
  - 'self.call'
  max_statements: 5

"app/workers":
  UtilityFunction:
    enabled: false

exclude_paths:
  - db
  - spec
CODE

file 'config/initializers/jsonapi_resources.rb', <<-CODE
require 'jsonapi-resources'

JSONAPI.configure do |config|
  config.json_key_format = :underscored_key

  # set some sensible limits
  config.default_page_size = 10
  config.maximum_page_size = 100

  # add pagination by default
  config.default_paginator = :offset
  config.top_level_meta_include_record_count = true
  config.top_level_meta_record_count_key = :record_count
end
CODE
