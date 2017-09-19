# frozen_string_literal: true
module <%= app_name.gsub(/^shift-/,'').camelize %>
  module V1
    class CommandsController < ApplicationApiController
      include Shift::Base::Rails::Engine::CommandsController
    end
  end
end