gem 'jsonapi-resources', '0.9.0.beta3'

gem_group :development, :test do
  gem 'rspec-rails', '~> 3.5'
end

gem_group :test do
  gem 'factory_girl_rails', '~> 4.7'
  gem 'faker', '~> 1.6'
  gem 'json_api_client', '~> 1.4'
end

# empty the existing bin scripts
run 'rm bin/*.rb'

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
  bundle install --jobs 4 --retry 5
  bundle exec rake db:migrate
  bundle exec rspec
CODE

file 'bin/docker/start_rails_server', <<-CODE
  #!/bin/bash
  echo "Installing gems..." && bundle install --jobs 4 --retry 5 --quiet && echo "Installed gems." && bundle exec rails s -b 0.0.0.0
CODE

file 'bin/docker/start_sidekiq', <<-CODE
  #!/bin/bash
  echo "Installing gems..." && bundle install --jobs 4 --retry 5 --quiet && echo "Installed gems." && bundle exec sidekiq -c 4
CODE

# make all scripts executable
run 'chmod +x -r bin/**/*'

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
      command: ./bin/docker/start_rails_server
      volumes:
        - .:/app
      volumes_from:
        - box
      ports:
        - '3000:3000'
      environment: &default_environment
        GEM_HOME: '/rubygems'
        BUNDLE_PATH: '/rubygems'
        DATABASE_URL: 'postgres://postgres:@postgres:5432'
        REDIS_URL: 'redis://redis:6379'
      depends_on:
        - postgres
        - redis
      links:
        - postgres
        - redis

    worker:
      command: ./bin/docker/start_sidekiq
      volumes:
        - .:/app
      volumes_from:
        - box
      environment:
        <<: *default_environment
      depends_on:
        - postgres
        - redis
        - web

    postgres:
      image: postgres:9.6
      ports:
        - '5432'
      volumes_from:
        - box

    redis:
      image: redis:3.2
      ports:
        - '6379'

    box:
      image: busybox
      volumes:
        - /rubygems
        - /var/lib/postgresql
CODE

file 'Dockerfile', <<-CODE
  FROM ruby:2.4.0
  MAINTAINER ryan@ryantownsend.co.uk

  # Install basic packages
  RUN apt-get update

  # Configure the main working directory
  ENV app /app
  RUN mkdir $app
  WORKDIR $app

  # Install bundler to manage Rubygems
  RUN gem install bundler --no-ri --no-rdoc

  ADD . $app
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
CODE
