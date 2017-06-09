require 'rspec_api_blueprint_matchers'
RSpecApib.config do |config|
  config.default_blueprint_file = File.expand_path("../../docs/api/root.apib", File.dirname(__FILE__))
end
