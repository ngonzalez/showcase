require 'net/http'
require 'uri'

class WebRegistrationJob < ApplicationJob
  queue_as :default

  attr_accessor :request_data

  def initialize(request_data)
    @request_data = request_data
  end

  def perform(*args)
    trigger_gateway
  # rescue Error::WebRegistration::InvalidRequest => exception
  #   Rails.logger.error(exception)
  end

  private

  def uri
    URI("http://#{NGINX_WEB_REGISTRATION_HOST}:#{NGINX_WEB_REGISTRATION_PORT}/api/v1/webRegistration.json")
    # URI("https://#{NGINX_WEB_REGISTRATION_HOST}:#{NGINX_WEB_REGISTRATION_PORT}/api/v1/webRegistration.json")
  end

  def trigger_gateway
    http = Net::HTTP.new(uri.host, uri.port)
    # http.use_ssl = true
    # http.ssl_version = 'SSLv3'
    # http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(uri.path)
    request.add_field('Content-Type', 'application/json')
    request.body = request_data

    http.request(request)
  # rescue StandardError => exception
  #   raise Error::WebRegistration::InvalidRequest
  end
end
