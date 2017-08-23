module SignInHelper

  def sign_in(code: "dummy_grant_token")
    visit "/?code=#{code}"
  end

end

RSpec.configure do |config|
  config.include SignInHelper, type: :feature
end