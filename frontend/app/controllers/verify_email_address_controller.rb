class VerifyEmailAddressController < RegistrationBaseController
  before_action :set_api_response, only: %i[create]

  attr_accessor :api_response

  def create
    redirect_to(validate_path(api_response: api_response.body.to_json, user: { payload: encrypt_user_payload(user_attributes) }))
  end

  private

  # The details submitted by the register form
  def set_user_attributes
    @user_attributes = params[:user].permit!.to_h if params[:user]
  end

  def set_api_response
    @api_response = web_registration_client.verify_email_address(backend_payload)
  end
end
