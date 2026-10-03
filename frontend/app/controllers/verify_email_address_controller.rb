class VerifyEmailAddressController < RegistrationBaseController
  before_action :set_api_response, only: %i[create]

  attr_accessor :api_response

  def create
    redirect_to(validate_path(api_response: api_response.body.to_json, user: { payload: user_payload }))
  end

  private

  def set_api_response
    @api_response = web_registration_client.verify_email_address(user_payload)
  end
end
