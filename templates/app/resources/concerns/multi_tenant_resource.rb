# frozen_string_literal: true
module MultiTenantResource
  extend ActiveSupport::Concern
  # scope records by account reference
  class_methods do
    def records(options = {})
      super.where(account_reference: options[:context][:account_reference])
    end
  end
end
