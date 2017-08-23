# frozen_string_literal: true
module <%= app_name.gsub(/^shift-/,'').camelize %>
  module V1
    class BaseResource < JSONAPI::Resource
      before_replace_fields :add_account_reference

      attributes :request_uuid

      attr_accessor :request_uuid

      def _save(validation_context = nil)
        return :completed if context.fetch(:duplicate_request, false)
        super
      end

      private

      def add_account_reference
        @model.account_reference = context[:account_reference]
      end
    end
  end
end
