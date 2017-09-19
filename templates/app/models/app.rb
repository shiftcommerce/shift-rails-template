# frozen_string_literal: true
module <%= app_name.gsub(/^shift-/,'').camelize %>
  AVAILABLE_PERMISSIONS = {

  }.freeze

  def self.table_name_prefix
    ""
  end

  def self.shared_secret
    @shared_secret ||= ENV.fetch("JWT_BOUNCER_SHARED_SECRET")
  rescue KeyError
    raise("The JWT_BOUNCER_SHARED_SECRET environment variable is not set")
  end
end
