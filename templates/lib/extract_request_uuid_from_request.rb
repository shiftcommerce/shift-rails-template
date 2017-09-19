require "action_dispatch"

class ExtractRequestUUIDFromRequest
  def initialize(app)
    @app = app
  end

  def call(env)
    request = ActionDispatch::Request.new(env)
    request_uuid = request.params.dig("data", "attributes", "request_uuid")
    env["shift_commerce.request_uuid"] = request_uuid if request_uuid
    @app.call(env)
  end
end