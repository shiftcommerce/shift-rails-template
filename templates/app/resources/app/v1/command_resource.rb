module <%= app_name.gsub(/^shift-/,'').camelize %>
  module V1
    class CommandResource < JSONAPI::Resource
      include Shift::Base::Rails::Engine::CommandResource
      abstract
    end
  end
end