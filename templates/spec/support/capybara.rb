Capybara.configure do |config|
  config.app_host = "http://yarn:4000"
  config.server_host = `/sbin/ip route|awk '/scope/ { print $9 }'`.chomp
end

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new app, browser: :remote,
                                      desired_capabilities: :chrome,
                                      url: "http://selenium:4444/wd/hub"
end
