class WebRegistrationController < RegistrationBaseController
  before_action :set_api_response, only: %i[create]

  attr_accessor :api_response

  def create
    if api_response.success?
      redirect_to(confirmation_path(api_response: api_response.body.to_json, user: { payload: user_payload }))
    else
      redirect_to(register_path(user: { payload: user_payload }), notice: I18n.t('web_registration.fail'))
    end
  end

  private

  def set_api_response
    @api_response = web_registration_client.web_registration(user_payload)
  end
end
