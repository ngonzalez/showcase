require 'net/http'
require 'uri'
require 'json'

class WebRegistrationJob < ApplicationJob
  queue_as :default

  attr_accessor :request_data

  def initialize(request_data)
    @request_data = JSON.parse(request_data)
  end

  def perform(*args)
    trigger_gateway
  rescue Error::WebRegistration::InvalidRequest => exception
    Rails.logger.error(exception)
    { "error": "API: Invalid Gateway" }
  end

  private

  def uri
    URI("https://#{NGINX_WEB_REGISTRATION_HOST}:#{NGINX_WEB_REGISTRATION_PORT}/api/v1/webRegistration.json")
  end

  def trigger_gateway
    request = Net::HTTP::Post.new(uri.request_uri)
    request['Authorization'] = "Bearer #{NGINX_WEB_REGISTRATION_TOKEN}"
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
