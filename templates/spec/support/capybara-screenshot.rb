if ENV.key?('SCREENSHOT_S3_ACCESS_KEY_ID') && ENV['SCREENSHOT_S3_ACCESS_KEY_ID'] != ''
  Capybara::Screenshot.s3_configuration = {
    s3_client_credentials: {
      access_key_id: ENV['SCREENSHOT_S3_ACCESS_KEY_ID'],
      secret_access_key: ENV['SCREENSHOT_S3_SECRET_ACCESS_KEY'],
      region: ENV['SCREENSHOT_S3_REGION']
    },
    bucket_name: "test-screenshots"
  }
end
Capybara::Screenshot.prune_strategy = :keep_last_run
