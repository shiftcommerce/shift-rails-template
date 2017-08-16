require "sidekiq/testing"

RSpec.configure do |config|
  config.before(:suite) do
    Sidekiq::Testing.fake!
  end

  # Drain all worker queues before each example
  config.before(:each) do
    Sidekiq::Worker.clear_all
  end

  config.around(:example, sidekiq: -> (mode) { !!mode }) do |example|
    unless %i(inline fake disable).include?(example.metadata.fetch(:sidekiq))
      raise "sidekiq_mode must be :inline, :fake or :disable"
    end
    Sidekiq::Testing.send("#{example.metadata.fetch(:sidekiq)}!".to_sym) do
      example.run
    end
  end
end
