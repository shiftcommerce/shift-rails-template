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
  gem 'json_api_client', '~> 1.4'
  gem 'rspec_tap', '~>0.1', require: false
  gem 'rspec_api_blueprint_matchers', '~> 0.1'
  gem 'capybara', '~> 2.14'
  gem 'capybara-screenshot', '~> 1.0'
  gem 'aws-sdk', '~> 2.9'
  gem 'selenium-webdriver', '~> 3.4'
end

# remove the database config file
run 'rm config/database.yml'

# remove the puma file
run 'rm config/puma.rb'

# remove the cors file
run 'rm config/initializers/cors.rb'

# empty the existing bin scripts
run 'rm -r bin'

template 'bin/dev/boot'
template 'bin/dev/bundle'
template 'bin/dev/dbconsole'
template 'bin/dev/guard'
template 'bin/dev/jest'
template 'bin/dev/rails'
template 'bin/dev/rake'
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

# git
template '.gitignore'

# Docker
template '.dockerignore'
template 'docker-compose.yml'
template 'Dockerfile.ruby'
template 'Dockerfile.yarn'

# Heroku app.json
template 'app.json'
template 'Procfile'
template 'Procfile.dev'

# Codeship
template 'codeship-services.yml'
template 'codeship-steps.yml'

# Rails config
template 'config/puma.rb'
template 'config/initializers/cors.rb'
template 'config/initializers/jsonapi_resources.rb'
template 'config/database.yml'

# Front end
template 'public/index.html'
template 'app/assets/javascripts/pages/WelcomePage.js'
template 'app/assets/javascripts/actions.js'
template 'app/assets/javascripts/configureStore.js'
template 'app/assets/javascripts/index.js'
template 'app/assets/javascripts/rootReducer.js'
template 'app/assets/stylesheets/application.css.scss'

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
template 'spec/support/rspec_api_blueprint_matchers.rb'
template 'spec/support/api_documentation_coverage.rb'
template 'spec/support/api_http_recorder.rb'
template 'spec/support/capybara.rb'
template 'spec/support/capybara-screenshot.rb'

# RSpec Throw away specs
template 'spec/integration/welcome_spec.rb'

# Starting point for API documentation
template 'docs/api/root.apib'
