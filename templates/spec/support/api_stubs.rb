# This file is for api calls that always want stubbing with the same response
# In this case we are stubbing the request for authentication tokens
require_relative "./helpers/proxy_helper"

ENV["OAUTH_SERVICE_BASE_URL"] = "http://shift-authentication-staging.herokuapp.com"

RSpec.configure do |config|
  config.before(:each, type: :feature) do
    set_proxy
  end
end
