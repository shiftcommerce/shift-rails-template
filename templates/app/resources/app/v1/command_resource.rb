module Pim
  module V1
    class CommandResource < JSONAPI::Resource
      include Shift::Base::Rails::Engine::CommandResource
      abstract
    end
  end
end