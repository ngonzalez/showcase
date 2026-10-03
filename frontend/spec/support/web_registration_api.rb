# Stubs for the web registration API of demo-app-backend-org.
#
# Response bodies follow the backend jbuilder views:
#   app/views/api/v1/verify_email_address/show.json.jbuilder
#   app/views/api/v1/web_registration/show.json.jbuilder
# and its error handling: `head(:bad_request)` for a missing/invalid payload
# or API token, so 400 responses have an empty body.
module WebRegistrationApi
  def web_registration_api_url(endpoint)
    "https://#{NGINX_WEB_REGISTRATION_HOST}:#{NGINX_WEB_REGISTRATION_PORT}/api/v1/#{endpoint}.json"
  end

  def stub_web_registration_api(endpoint, status:, body: nil)
    stub_request(:post, web_registration_api_url(endpoint)).to_return(
      status: status,
      body: body.nil? ? "" : body.to_json,
      headers: { 'Content-Type' => 'application/json; charset=utf-8' }
    )
  end

  def user_attributes(overrides = {})
    {
      accountType: "company",
      companyName: "Example Company",
      firstName: "Anna",
      lastName: "Smith",
      emailAddress: "anna.smith@example.com",
      address: "38 rue d'Hauteville",
      postalCode: "75010",
      city: "Paris",
      country: "France",
      plan: "10GB",
      password: "Password1234",
      passwordConfirmation: "Password1234",
    }.merge(overrides)
  end

  # The payload sent to the backend
  def encode_payload(attributes)
    Base64.strict_encode64(attributes.to_json)
  end

  # The payload passed between the registration pages
  def encrypt_payload(attributes)
    EncryptHelpers.encrypt(attributes.to_json)
  end

  def decrypt_payload(payload)
    JSON.parse(EncryptHelpers.decrypt(payload), symbolize_names: true)
  end

  def redirect_params
    Rack::Utils.parse_nested_query(URI(response.location).query)
  end

  def verify_email_address_body(verify_account: [], verify_user: [])
    { verifyAccount: verify_account, verifyUser: verify_user }
  end

  def web_registration_success_body
    {
      account: { uuid: SecureRandom.uuid, name: "Example Company", address: "38 rue d'Hauteville 75010 Paris France" },
      message: "Account found in our database",
    }
  end

  def web_registration_fail_body
    { message: "Account not found in our database" }
  end
end

RSpec.configure do |config|
  config.include WebRegistrationApi
end

RSpec::Matchers.define :not_expose_password do |attributes|
  match do |content|
    content = CGI.unescape(content.to_s)
    [attributes[:password], Base64.strict_encode64(attributes.to_json)].none? { |secret| content.include?(secret) }
  end

  failure_message { |content| "expected the password not to appear in clear or Base64 in:\n#{content}" }
end
