def use_memcache
  return @use_memcache unless @use_memcache.nil?
  @use_memcache = yes?("Will you need memcache? (It is required to be setup in Dockerfile and app.json)")
end

def source_paths
  [File.expand_path('./templates', File.dirname(__FILE__))]
end

# API framework
gem 'jsonapi-resources', '0.9.0'
# Add CORS headers
gem 'rack-cors', '~> 0.4', '>= 0.4.1'
# Background processing
gem 'sidekiq', '~> 5.0'
if use_memcache
  # Caching
  gem "dalli", "~> 2.7", ">= 2.7.6"
end
gem_group :development do
  gem 'reek', '~> 4.5'
  gem 'rubocop', '0.46'
  gem 'foreman', '~> 0.83', '>= 0.83'
  gem 'guard-rspec', '~> 4.7.3', require: false
end

gem_group :development, :test do
  gem 'rspec-rails', '~> 3.6'
  gem 'pry', '~> 0.10'
end

gem_group :test do
  gem 'factory_girl_rails', '~> 4.7'
  gem 'faker', '~> 1.7'
  gem 'rspec-support'
  gem 'rspec_tap', '~>0.1', require: false
  gem 'webmock', '~> 2.3.2'
  gem 'database_cleaner', '~> 1.6.1'
  gem 'capybara', '~> 2.13.0'
  gem 'capybara-screenshot', '~> 1.0'
  gem 'aws-sdk', '~> 2.9'
  gem 'selenium-webdriver', '~> 3.3.0'
  gem 'chromedriver-helper'
  gem 'rspec_api_blueprint_matchers', '~> 0.1'
  gem 'puffing-billy'
  gem 'json_api_client', '~> 1.4'
end

gem 'shift_commerce_' + app_name.gsub(/^shift-/,''), path: 'vendor/gems/shift_commerce_' + app_name.gsub(/^shift-/,'')

gem 'jwt-bouncer', '0.1.1'

# remove the database config file
run 'rm config/database.yml'

# remove the puma file
run 'rm config/puma.rb'

# remove the database config file
run 'rm config/application.rb'

# remove the routes file
run 'rm config/routes.rb'

# remove the cors file
run 'rm config/initializers/cors.rb'

# remove development and production environment configs
run 'rm config/environments/development.rb'
run 'rm config/environments/production.rb'

# empty the existing bin scripts
run 'rm -r bin'

# remove existing git ignore file
run 'rm .gitignore'

template 'bin/dev/boot'
template 'bin/dev/bundle'
template 'bin/dev/dbconsole'
template 'bin/dev/guard'
template 'bin/dev/jest'
template 'bin/dev/rails'
template 'bin/dev/rake'
template 'bin/dev/recreate-test-db'
template 'bin/dev/rspec'
template 'bin/dev/run'
template 'bin/dev/yarn'
template 'bin/docker/ruby_entrypoint'
template 'bin/docker/yarn_entrypoint'
template 'bin/docker/dbconsole'

template 'bin/rails'
template 'bin/rake'

# make all scripts executable
run 'chmod +x bin/docker/* bin/* bin/dev/*'

# blank env example file
template ".env.example"

# git
template '.gitignore'
template '.github/PULL_REQUEST_TEMPLATE.md'

# Docker
template '.dockerignore'
template 'docker-compose.yml'
template 'docker-compose-test.yml'
template 'docker-compose-env.yml'
template 'Dockerfile.ruby'
template 'Dockerfile.yarn'
template 'Dockerfile.codeship'

# Heroku app.json
template 'app.json'
template 'Procfile'
template 'Procfile.dev'

# Codeship
template 'codeship-services.yml'
template 'codeship-steps.yml'

# Rails config
template 'config/application.rb'
template 'config/puma.rb'
template 'config/routes.rb'
template 'config/initializers/cors.rb'
template 'config/initializers/jsonapi_resources.rb'
template 'config/database.yml'
template 'config/environments/development.rb'
template 'config/environments/production.rb'

# Front end
template 'public/index.html'
template 'app/assets/javascripts/pages/WelcomePage.js'
template 'app/assets/javascripts/actions.js'
template 'app/assets/javascripts/configureStore.js'
template 'app/assets/javascripts/index.js'
template 'app/assets/javascripts/rootReducer.js'
template 'app/assets/stylesheets/application.css.scss'
template 'app/controllers/home_controller.rb'
template 'app/views/home/index.html.erb'

# Event Store Boilerplate
template 'app/controllers/application_api_controller.rb'
template 'app/controllers/commands_controller.rb', 'app/controllers/' + app_name.gsub(/^shift-/,'') + '/v1/commands_controller.rb'
template 'app/resources/app/v1/command_resource.rb', 'app/resources/' + app_name.gsub(/^shift-/,'') + '/v1/command_resource.rb'
template 'config/initializers/shift_event_store.rb'
template 'db/migrate/create_shift_event_store_event_records.rb', 'db/migrate/' + Time.now.strftime("%Y%m%d%H%M%S") + '_create_shift_event_store_event_records.rb'

# Ruby Boilerplate
template 'app/models/app.rb', 'app/models/' + app_name.gsub(/^shift-/,'') + '.rb'
template 'app/resources/concerns/multi_tenant_resource.rb'
template 'lib/duplicate_request_detection.rb'
template 'lib/extract_request_uuid_from_request.rb'

# Node config
template 'package.json'
template 'webpack.config.js'
template '.babelrc'

# Code quality tools
template '.codeclimate.yml'
template '.reek'
template '.rubocop.yml'
template 'config/rubocop/.lint_rubocop.yml'
template 'config/rubocop/.metrics_rubocop.yml'
template 'config/rubocop/.performance_rubocop.yml'
template 'config/rubocop/.rails_rubocop.yml'
template 'config/rubocop/.style_rubocop.yml'

# RSpec Setup
template '.rspec'
template 'spec/rails_helper.rb'
template 'spec/spec_helper.rb'
template 'spec/support/helpers/proxy_helper.rb'
template 'spec/support/helpers/jwt_bouncer_helpers.rb'
template 'spec/support/api_documentation_coverage.rb'
template 'spec/support/api_http_recorder.rb'
template 'spec/support/api_stubs.rb'
template 'spec/support/application_proxy.rb'
template 'spec/support/capybara.rb'
template 'spec/support/capybara-screenshot.rb'
template 'spec/support/database_cleaner.rb'
template 'spec/support/jestStyleMock.js'
template 'spec/support/rspec_api_blueprint_matchers.rb'

# RSpec Throw away specs
template 'spec/admin/integration/welcome_spec.rb'
template 'spec/admin/components/WelcomePage.spec.js'
template 'spec/api/v1/app/.keep', 'spec/api/v1/' + app_name.gsub(/^shift-/,'') + '/.keep'

# Ruby gem in vendor
directory 'vendor/gems/shift_commerce_app/other', 'vendor/gems/shift_commerce_' + app_name.gsub(/^shift-/,'')
template 'vendor/gems/shift_commerce_app/app/models/app/base.rb', 'vendor/gems/shift_commerce_' + app_name.gsub(/^shift-/,'') + '/app/models/' + app_name.gsub(/^shift-/,'') + '/base.rb'
template 'vendor/gems/shift_commerce_app/bin/console', 'vendor/gems/shift_commerce_' + app_name.gsub(/^shift-/,'') + '/bin/console'
template 'vendor/gems/shift_commerce_app/bin/setup', 'vendor/gems/shift_commerce_' + app_name.gsub(/^shift-/,'') + '/bin/setup'
template 'vendor/gems/shift_commerce_app/lib/shift_commerce/app.rb', 'vendor/gems/shift_commerce_' + app_name.gsub(/^shift-/,'') + '/lib/shift_commerce/' + app_name.gsub(/^shift-/,'') + '.rb'
template 'vendor/gems/shift_commerce_app/lib/shift_commerce_app/version.rb', 'vendor/gems/shift_commerce_' + app_name.gsub(/^shift-/,'') + '/lib/shift_commerce_' + app_name.gsub(/^shift-/,'') + '/version.rb'
template 'vendor/gems/shift_commerce_app/lib/shift_commerce_app.rb', 'vendor/gems/shift_commerce_' + app_name.gsub(/^shift-/,'') + '/lib/shift_commerce_' + app_name.gsub(/^shift-/,'') + '.rb'
template 'vendor/gems/shift_commerce_app/shift_commerce_app.gemspec', 'vendor/gems/shift_commerce_' + app_name.gsub(/^shift-/,'') + '/shift_commerce_' + app_name.gsub(/^shift-/,'') + '.gemspec'
template 'vendor/gems/shift_commerce_app/Gemfile', 'vendor/gems/shift_commerce_' + app_name.gsub(/^shift-/,'') + '/Gemfile'
template 'vendor/gems/shift_commerce_app/README.md', 'vendor/gems/shift_commerce_' + app_name.gsub(/^shift-/,'') + '/README.md'

# Starting point for API documentation
template 'docs/api/root.apib'

append_to_file "Gemfile" do
  "\n\ngem 'shift_event_store', git: 'https://' + ENV.fetch('GITHUB_REPO_ACCESS_KEY','') + ':x-oauth-basic@github.com/shiftcommerce/shift-event-store'
gem 'shift-base-rails-engine', git: 'https://' + ENV.fetch('GITHUB_REPO_ACCESS_KEY','') + ':x-oauth-basic@github.com/shiftcommerce/shift-base-rails-engine'"
end
