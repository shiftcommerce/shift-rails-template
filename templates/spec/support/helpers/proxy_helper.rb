module ProxyHelper
  def set_proxy(permissions: "::<%= app_name.gsub(/^shift-/,'').camelize %>::AVAILABLE_PERMISSIONS".constantize, response: nil, url: nil, request_method: "post")
    token_exchange_url = "#{ENV.fetch("OAUTH_SERVICE_BASE_URL", "")}/oauth2/token"
    token = generate_authorization_token(
      account_reference: 'test_account',
      permissions: { <%= app_name.gsub(/^shift-/,'').camelize %>: permissions }
    )
    json_response = {
      data: {
        type: 'oauth2/tokens',
        attributes: {
          access_token:   token,
          refresh_token:  "dummy_refresh_token",
          token_type:     "bearer",
          expires_in:     899
        }
      }
    }

    proxy.stub(
      (url || token_exchange_url),
      method: request_method
    ).and_return(
      {
        :headers => { 'Access-Control-Allow-Origin' => '*' },
        :json    => (response || json_response)
      }
    )
  end
end

RSpec.configure do |config|
  config.include ProxyHelper, type: :feature
end
