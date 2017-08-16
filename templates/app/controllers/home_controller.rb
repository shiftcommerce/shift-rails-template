# frozen_string_literal: true
class HomeController < ActionController::Base

  protect_from_forgery with: :exception
  
  OAUTH_CONFIG = {
    service_base_url: ENV.fetch("OAUTH_SERVICE_BASE_URL", ""),
    redirect_url: ENV.fetch("OAUTH_REDIRECT_URL", ""),
    client_id: ENV.fetch("OAUTH_CLIENT_ID", "")
  }.freeze
  
  def index
    config = {
      oauth:  OAUTH_CONFIG
    }
    render locals: { config: config }
  end

end