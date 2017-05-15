module HttpRecorder
  # Allows easy recording of http transactions, giving access to the
  # recorder in the tests as "http_recorder".
  # Including this module in rspec will automatically start and stop the Recorder
  # in "api" or "request" specs.
  module Helper
    def http_recorder
      @http_recorder
    end

    def start_http_recorder
      @http_recorder = Recorder.new
    end

    def stop_http_recorder
      return if @http_recorder.nil?
      @http_recorder.stop
      @http_recorder = nil
    end
  end

  # An instance of this will setup the shift base gem to record
  # all http transactions into this instance for review by the tests.
  class Recorder
    Transaction = Struct.new(:request, :response)
    def initialize
      self.recorded_transactions = []
      ::Shift::Api::Core.config do |config|
        config.after_response method(:record)
        config.before_request method(:tag_request)
      end
    end

    def stop
      ::Shift::Api::Core.config do |config|
        # @TODO This should really have a delete_after_response method in gem
        config.after_response_handlers.delete(method(:record))
      end
    end

    def transactions
      recorded_transactions
    end

    private

    def record(request, response)
      recorded_transactions << Transaction.new(request, response)
    end

    def tag_request(request)
      called_from_specs = caller.select {|s| s =~ /spec\/.*_spec.rb/}
      request[:rspec_caller] = called_from_specs.first unless called_from_specs.empty?
    end

    attr_accessor :recorded_transactions

  end
end

if Object.const_defined?('Shift') && Shift.const_defined?('Api') && Shift::Api.const_defined?('Core')
  RSpec.configure do |config|
    config.include HttpRecorder::Helper, type: :api
    config.include HttpRecorder::Helper, type: :request
    config.before(:each, type: :api) { start_http_recorder }
    config.before(:each, type: :request) { start_http_recorder }
    config.after(:each, type: :api) { stop_http_recorder }
    config.after(:each, type: :request) { stop_http_recorder }
  end
else
  Rails.logger.warn("Warning - HTTP Recorder not started - The API HTTP Recorder (spec/support/api_http_recorder.rb) will only work once you have an API access gem in your project as it required Shift::Api::Core")
end
