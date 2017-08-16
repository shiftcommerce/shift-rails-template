# frozen_string_literal: true
module ShiftCommerce
  module <%= app_name.gsub(/^shift-/,'').camelize %>
    class Base < Shift::Api::Core::Model
      def self.type
        "<%= app_name.gsub(/^shift-/,'') %>/#{super}"
      end
    end
  end
end
