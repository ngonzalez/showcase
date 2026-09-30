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
    send_request
  rescue Error::Http::InvalidRequest => exception
    Rails.logger.error(exception)
  end

  private

  def uri
    URI("http://#{NGINX_WEB_REGISTRATION_HOST}:#{NGINX_WEB_REGISTRATION_PORT}/api/v1/web_registration.json")
  end

  def send_request
    request = Net::HTTP::Post.new(uri.request_uri)
    request['Authorization'] = "Bearer #{NGINX_WEB_REGISTRATION_TOKEN}"
    request['Content-Type'] = 'application/json'
    request['Accept'] = 'application/json'
    request.body = request_data.to_json

    response = Net::HTTP.start(uri.host, uri.port, use_ssl: false, open_timeout: 10, read_timeout: 60) do |http|
      http.request(request)
    end
  rescue StandardError => exception
    raise Error::Http::InvalidRequest
  end
end
