# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'capybara/rspec'
require 'capybara-screenshot/rspec'


Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
# ActiveRecord::Migration.maintain_test_schema!
# Custom message for pending Migrations

if ActiveRecord::Migrator.needs_migration?
  raise ActiveRecord::PendingMigrationError,
        "Migrations are pending. To resolve this issue, run:\n
        ./bin/dev/rake db:migrate RAILS_ENV=test"
end

Billy.configure do |config|
  config.cache = false
  config.proxy_host = '0.0.0.0' # defaults to localhost
  config.proxy_port = 43001
end

RSpec.configure do |config|
  config.use_transactional_fixtures = false
end
