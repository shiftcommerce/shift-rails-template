require_relative "./api_http_recorder"
if ENV.fetch("RSPEC_FORCE_API_DOCUMENTATION_COVERAGE", "false") == "true"
  RSpec.configure do |config|
    global_recorder = nil
    config.before(:suite) { global_recorder = HttpRecorder::Recorder.new }
    config.after(:suite) do
      global_recorder.stop
      expect(global_recorder.transactions).to have_covered_all_api_documentation
    end
  end
end
