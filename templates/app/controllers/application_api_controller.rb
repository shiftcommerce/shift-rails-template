# frozen_string_literal: true
require "extract_request_uuid_from_request"
require "duplicate_request_detection"
require "jwt_bouncer"

class ApplicationApiController < ActionController::API

  include JSONAPI::ActsAsResourceController
  include Shift::Base::Rails::Engine::BaseController

  use Shift::Base::Rails::Engine::Authorisation,
    shared_secret: <%= app_name.gsub(/^shift-/,'').camelize %>.shared_secret,
    permissions_group: "<%= app_name.gsub(/^shift-/,'').camelize %>"

  use ExtractRequestUUIDFromRequest
  use DuplicateRequestDetection

  def context
    {
      account_reference: request.env.fetch("jwt_bouncer.account_reference")
    }
  end
end
