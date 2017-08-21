This template sets up a new Rails application with Docker Compose and relevant scripts configured.

```bash
rails new app_name -d postgresql --skip-test --skip-action-cable --skip-action-mailer --skip-keeps --skip-bundle --skip-listen --skip-spring --api -m https://raw.githubusercontent.com/shiftcommerce/shift-rails-template/master/template.rb
```

You can also apply this to an existing Rails app using:

```bash
./bin/rails app:template LOCATION=https://raw.githubusercontent.com/shiftcommerce/shift-rails-template/master/template.rb
```

*Note:* This template was designed with rails 5.1 in mind but may well work with others, but not tested

### Features

* Sets up Rails & Sidekiq as primary services
* Configures PostgreSQL and Redis as dependencies
* Implements a Rubygem cache so each build doesn't require re-downloading and rebuilding of all gems
* Sets a persisted volume for PostgreSQL so your database isn't trashed between container rebuilds

### Codeship

To allow codeship testing after booting the app you will need to do the following:
* Populate a .env file based on the .env.example file
* Add the codeship AES key, found under the General tab of the codeship project dashboard, to your local machine in the codeship.aes file.
* With the gem `jet` installed locally run `jet encrypt .env env.encrypted` to generate the encrypted variables
* Commit this file to give codeship access.

See Codeship docs for more info
https://documentation.codeship.com/pro/builds-and-configuration/environment-variables/