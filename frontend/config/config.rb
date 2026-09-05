require 'active_support'
require 'active_support/core_ext'
require 'dotenv/load'
require 'yaml'

# APP_HOSTNAME
if ENV['APP_HOSTNAME'].present?
  APP_HOSTNAME = ENV['APP_HOSTNAME']
else
  raise "Missing ENV APP_HOSTNAME"
end

# APP_PORT
if ENV['APP_PORT'].present?
  APP_PORT = ENV['APP_PORT']
else
  raise "Missing ENV APP_PORT"
end

# SECRET_KEY_BASE
if ENV['SECRET_KEY_BASE'].present?
  SECRET_KEY_BASE = ENV['SECRET_KEY_BASE']
else
  raise "Missing ENV SECRET_KEY_BASE"
end

# NGINX_HOST
if ENV['NGINX_HOST'].present?
  NGINX_HOST = ENV['NGINX_HOST']
else
  raise "Missing ENV NGINX_HOST"
end

# NGINX_PORT
if ENV['NGINX_PORT'].present?
  NGINX_PORT = ENV['NGINX_PORT']
else
  raise "Missing ENV NGINX_PORT"
end

# NGINX_STATUS_PORT
if ENV['NGINX_STATUS_PORT'].present?
  NGINX_STATUS_PORT = ENV['NGINX_STATUS_PORT']
else
  raise "Missing ENV NGINX_STATUS_PORT"
end

# POSTGRESQL_HOST
if ENV['POSTGRESQL_HOST'].present?
  POSTGRESQL_HOST = ENV['POSTGRESQL_HOST']
else
  raise "Missing ENV POSTGRESQL_HOST"
end

# POSTGRESQL_PORT
if ENV['POSTGRESQL_PORT'].present?
  POSTGRESQL_PORT = ENV['POSTGRESQL_PORT']
else
  raise "Missing ENV POSTGRESQL_PORT"
end

# POSTGRESQL_DB
if ENV['POSTGRESQL_DB'].present?
  POSTGRESQL_DB = ENV['POSTGRESQL_DB']
else
  raise "Missing ENV POSTGRESQL_DB"
end

# POSTGRESQL_USERNAME
if ENV['POSTGRESQL_USERNAME'].present?
  POSTGRESQL_USERNAME = ENV['POSTGRESQL_USERNAME']
else
  raise "Missing ENV POSTGRESQL_USERNAME"
end

# POSTGRESQL_PASSWORD
if ENV['POSTGRESQL_PASSWORD'].present?
  POSTGRESQL_PASSWORD = ENV['POSTGRESQL_PASSWORD']
else
  raise "Missing ENV POSTGRESQL_PASSWORD"
end
