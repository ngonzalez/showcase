require 'net/http'
require 'uri'
require 'json'

class VerifyEmailAddressJob < ApplicationJob
  queue_as :default

  attr_accessor :request_data

  def initialize(request_data)
    @request_data = JSON.parse(request_data)
  end

  def perform(*args)
    trigger_gateway
  rescue Error::WebRegistration::InvalidRequest => exception
    Rails.logger.error(exception)
  end

  private

  def uri
    URI("https://#{NGINX_WEB_REGISTRATION_HOST}:#{NGINX_WEB_REGISTRATION_PORT}/api/v1/verify_email_address.json")
  end

  def trigger_gateway
    token = 'eyJhbGciOiJFUzM4NCJ9.eyJ1c2VyX2lkIjoxLCJhY2NvdW50X3V1aWQiOiI3NjJhNzhkZi02NDI3LTRmNGItYjIyOC1mZWNjZWU1ZWMwNWQiLCJleHAiOjE4MjIyNDk3NDR9.bmBUysGHDwXVymjpgKiQsNKUT6RtIPnzv4Ff1kKVnzKmK3UNvP2vSM30FD21IJRwqOTubXCRUhLQEVvT30S4p6yapDIyti0EOAStyE6gTGjR2cNRz5QYoYEWFjC4LXbQ'

    request = Net::HTTP::Post.new(uri.request_uri)
    request['Authorization'] = "Bearer #{token}"
    request['Content-Type'] = 'application/json'
    request['Accept'] = 'application/json'
    request.body = request_data.to_json

    response = Net::HTTP.start(uri.host, uri.port, use_ssl: true, open_timeout: 10, read_timeout: 60) do |http|
      http.request(request)
    end
  rescue StandardError => exception
    raise Error::WebRegistration::InvalidRequest
  end
end
