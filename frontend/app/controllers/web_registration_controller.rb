class WebRegistrationController < RegistrationBaseController
  before_action :set_api_response, only: %i[create]

  attr_accessor :api_response

  def create
    if api_response.success?
      redirect_to(confirmation_path(api_response: api_response.body.to_json))
    else
      redirect_to(register_path(plan: user_attributes[:plan]), notice: I18n.t('web_registration.fail'))
    end
  end

  private

  # The encrypted details submitted by the validate form
  def set_user_attributes
    @user_attributes = decrypt_user_payload(params.dig(:user, :payload))
  end

  def set_api_response
    @api_response = web_registration_client.web_registration(backend_payload)
  end
end
