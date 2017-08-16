require 'capybara'
require 'selenium/webdriver'
require 'mkmf'
require "capybara-screenshot/rspec"
require 'billy/capybara/rspec'

RSpec.configure do |config|
  config.before(:each, type: :feature) do
    server = Capybara.current_session.server
    Capybara.app_host = "http://#{server.host}:#{server.port}"
  end

  config.append_after(:each, type: :feature) do
    Capybara.reset_sessions!
    Capybara.use_default_driver
    Capybara.app_host = nil
  end
end

# if configuring for use locally
if ENV['SELENIUM_URL'].present?
  Capybara.configure do |config|
    config.server_host = `/sbin/ip route|awk '/scope/ { print $9 }'`.chomp
  end
end

Capybara.register_driver :selenium do |app|
  chrome_billy = Selenium::WebDriver::Remote::Capabilities.chrome(proxy: Selenium::WebDriver::Proxy.new(http: "#{`/sbin/ip route|awk '/scope/ { print $9 }'`.chomp}:43001"))

  if ENV['SELENIUM_URL'].present?
    Capybara::Selenium::Driver.new(app,
      browser: :remote,
      url: ENV['SELENIUM_URL'],
      desired_capabilities: chrome_billy
    )
  else
    Capybara::Selenium::Driver.new(app, browser: :chrome, desired_capabilities: chrome_billy)
  end
end

Capybara::Screenshot.register_driver(:selenium) do |driver, path|
  driver.browser.save_screenshot(path)
end

# Keep only the screenshots generated from the last failing test suite
Capybara::Screenshot.prune_strategy = :keep_last_run
