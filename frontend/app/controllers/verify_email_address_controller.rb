class VerifyEmailAddressController < RegistrationBaseController

  def create
    redirect_to(validate_path(api_response: @verify_email_address_response.body, user: { payload: user_payload }))
  end

  private

  def create_job
    @verify_email_address_response = VerifyEmailAddressJob.new({ payload: user_payload }.to_json).perform
  end
end
