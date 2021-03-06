This template sets up a new Rails application with Docker Compose and relevant scripts configured.

```bash
rails new app_name -d postgresql --skip-test --skip-action-cable --skip-action-mailer --skip-keeps --skip-bundle --skip-listen --skip-spring --api -m https://raw.githubusercontent.com/ryantownsend/rails-template/master/template.rb
```

You can also apply this to an existing Rails app using:

```bash
./bin/rails app:template LOCATION=https://raw.githubusercontent.com/ryantownsend/rails-template/master/template.rb
```

*Note:* only Rails 5 is supported.

### Features

* Sets up Rails & Sidekiq as primary services
* Configures PostgreSQL and Redis as dependencies
* Implements a Rubygem cache so each build doesn't require re-downloading and rebuilding of all gems
* Sets a persisted volume for PostgreSQL so your database isn't trashed between container rebuilds
