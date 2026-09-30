class VerifyEmailAddressController < RegistrationBaseController
  before_action :create_job, only: %i[create]
  before_action :set_api_response, only: %i[create]

  attr_accessor :api_response
  helper_method :api_response

  def create
    redirect_to(validate_path(api_response: api_response, user: { payload: user_payload }))
  end

  private

  def create_job
    @verify_email_address_response = VerifyEmailAddressJob.new({ payload: user_payload }.to_json).perform
  end

  def set_api_response
    @api_response = @verify_email_address_response.body
  end
end
