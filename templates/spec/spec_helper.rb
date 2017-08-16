require 'webmock/rspec'
require 'support/database_cleaner'
require 'billy/capybara/rspec'

RSpec.configure do |config|
  config.order = 'random'
  config.color = true

  config.before(:suite) do
    WebMock.disable_net_connect!(allow_localhost: true)
    WebMock.allow_net_connect!
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

end
