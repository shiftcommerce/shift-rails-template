require "jwt_bouncer/sign_request"

namespace :shift_commerce do
  namespace :<%= app_name.gsub(/^shift-/,'') %> do
    desc "Creates an outputs an authentication token"
    task create_authentication_token: :environment do
      # Create and print authentication token
      authorization = JwtBouncer::SignRequest.generate_token(
        permissions: { <%= app_name.gsub(/^shift-/,'').camelize %>: ::<%= app_name.gsub(/^shift-/,'').camelize %>::AVAILABLE_PERMISSIONS },
        actor: { type: "user", id: 1, name: "Jenkins" },
        account_reference: ENV.fetch("SEED_ACCOUNT_REFERENCE", "test"),
        shared_secret: ::<%= app_name.gsub(/^shift-/,'').camelize %>.shared_secret,
        expiry: nil
      )

      puts ""
      puts "Authorisation Token:"
      puts "-" * 80
      puts authorization
      puts "-" * 80
      puts "The key is between the dashes above"
    end
  end
end
