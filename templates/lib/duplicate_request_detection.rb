# frozen_string_literal: true

class DuplicateRequestDetection
  REQUEST_UUID_EXPIRY_PERIOD = ENV.fetch("REQUEST_UUID_EXPIRY_PERIOD", 1.week).to_i

  RESPONSE_CONFLICT = [
      409,
      { "Content-Type" => "application/vnd.api+json" }.freeze,
      [
        {
          "errors" => {
            "status" => "409",
            "source" => { "pointer" => "/data/attributes/request_uuid" }.freeze,
            "title"  => "Duplicate Request",
            "detail" => "A duplicate request has been made using the same request_uuid but a different request body"
          }.freeze
        }.to_json.freeze
      ].freeze
    ].freeze

  def initialize(app, cache: Rails.cache)
    @app = app
    @cache = cache
  end

  def call(env)
    # Get the request_uuid from the environment
    request_uuid = env["shift_commerce.request_uuid"]
    return @app.call(env) unless request_uuid

    # Combine the request_uuid with the account reference
    request_uuid = [env["jwt_bouncer.account_reference"], request_uuid].join("/")

    # Create a MD5 hash of the request body and rewind the input stream
    hash = Digest::MD5.digest(env["rack.input"].read)
    env["rack.input"].rewind

    # Check if the request_uuid has been used.
    request_uuid_used = request_uuid_used?(request_uuid)
    if request_uuid_used
      # For a request_uuid that has been used we fetch the hash of the previous request and compare with the current request
      existing_hash = hash_for_request_uuid(request_uuid)
      return RESPONSE_CONFLICT if hash != existing_hash
    end

    # Set an environment variable with the state of the request_uuid.
    # It is not the responsibility of this middleware to determine the course of action when duplicate requests are received.
    # This is left up to the application.
    env["shift_commerce.duplicate_request"] = request_uuid_used

    # Call the next thing and mark the request_uuid as used.
    @app.call(env).tap do
      use_request_uuid(request_uuid, hash)
    end
  end

  private

  def request_uuid_used?(request_uuid)
    @cache.exist?(request_uuid)
  end

  def use_request_uuid(request_uuid, hash)
    @cache.write(request_uuid, hash, expires_in: REQUEST_UUID_EXPIRY_PERIOD)
  end

  def hash_for_request_uuid(request_uuid)
    @cache.read(request_uuid)
  end
end