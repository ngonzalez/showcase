require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'

# config/config.rb raises on any missing variable: use test values, so specs
# never depend on /etc/secrets/.env (Dotenv doesn't override variables already set).
{
  'APP_HOSTNAME' => 'showcase.test',
  'APP_PORT' => '3000',
  'SECRET_KEY_BASE' => 'test-secret-key-base',
  'NGINX_HOST' => 'showcase.test',
  'NGINX_PORT' => '443',
  'NGINX_STATUS_PORT' => '8080',
  'NGINX_WEB_REGISTRATION_HOST' => 'backend.test',
  'NGINX_WEB_REGISTRATION_PORT' => '443',
  'NGINX_WEB_REGISTRATION_TOKEN' => 'test-api-token',
  'POSTGRESQL_HOST' => 'localhost',
  'POSTGRESQL_PORT' => '5432',
  'POSTGRESQL_DB' => 'showcase',
  'POSTGRESQL_USERNAME' => 'showcase',
  'POSTGRESQL_PASSWORD' => 'showcase',
}.each { |name, value| ENV[name] = value }

require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
# Requests to the backend (demo-app-backend-org) are stubbed: see spec/support/web_registration_api.rb
require 'webmock/rspec'

# Load every application file, so SimpleCov reports the ones no spec loads
Rails.autoloaders.main.dirs
  .select { |dir| dir.start_with?(Rails.root.join('app').to_s) }
  .each { |dir| Rails.autoloaders.main.eager_load_dir(dir) }

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

RSpec.configure do |config|
  # The application has no models: don't open a database transaction around examples
  config.use_transactional_fixtures = false

  config.infer_spec_type_from_file_location!
end
