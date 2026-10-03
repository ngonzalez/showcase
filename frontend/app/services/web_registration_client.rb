require 'net/http'
require 'uri'
require 'json'

# HTTP client for the web registration API of the backend (demo-app-backend-org):
#
#   POST /api/v1/verify_email_address.json
#   POST /api/v1/web_registration.json
#
# Both endpoints take `{ payload: <Base64 encoded JSON object> }` and answer
# 200 or 422 with a JSON body; anything else is an unusable response.
class WebRegistrationClient
  OPEN_TIMEOUT = 10
  READ_TIMEOUT = 60

  HANDLED_STATUSES = [200, 422].freeze

  NETWORK_ERRORS = [
    IOError,
    SocketError,
    SystemCallError,
    Timeout::Error,
    OpenSSL::SSL::SSLError,
    Net::HTTPBadResponse,
    Net::ProtocolError,
  ].freeze

  Response = Data.define(:status, :body) do
    def success?
      status == 200
    end
  end

  def verify_email_address(payload)
    post("verify_email_address", payload)
  end

  def web_registration(payload)
    post("web_registration", payload)
  end

  private

  def uri(endpoint)
    URI("https://#{NGINX_WEB_REGISTRATION_HOST}:#{NGINX_WEB_REGISTRATION_PORT}/api/v1/#{endpoint}.json")
  end

  def post(endpoint, payload)
    response = send_request(uri(endpoint), payload)
    status = response.code.to_i

    unless HANDLED_STATUSES.include?(status)
      raise Error::Http::InvalidResponse, "#{endpoint}: unexpected HTTP status #{status}"
    end

    Response.new(status: status, body: JSON.parse(response.body))
  rescue JSON::ParserError => exception
    Rails.logger.error("#{endpoint}: #{exception.message}")
    raise Error::Http::InvalidResponse, "#{endpoint}: invalid JSON body"
  end

  def send_request(uri, payload)
    request = Net::HTTP::Post.new(uri.request_uri)
    request['Authorization'] = "Bearer #{NGINX_WEB_REGISTRATION_TOKEN}"
    request['Content-Type'] = 'application/json'
    request['Accept'] = 'application/json'
    request.body = { payload: payload }.to_json

    Net::HTTP.start(uri.host, uri.port, use_ssl: true, open_timeout: OPEN_TIMEOUT, read_timeout: READ_TIMEOUT) do |http|
      http.request(request)
    end
  rescue *NETWORK_ERRORS => exception
    Rails.logger.error("#{uri}: #{exception.class}: #{exception.message}")
    raise Error::Http::InvalidRequest, exception.message
  end
end
