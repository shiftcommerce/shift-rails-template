# frozen_string_literal: true
module Pim
  module V1
    class CommandsController < ApplicationApiController
      include Shift::Base::Rails::Engine::CommandsController
    end
  end
end