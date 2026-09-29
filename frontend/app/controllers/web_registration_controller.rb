class WebRegistrationController < RegistrationBaseController
  before_action :create_job, only: %i[create]

  def create
    redirect_to(confirmation_path(api_response: @web_registration_response.body, user: { payload: user_payload }))
  end

  private
  
  def create_job
    @web_registration_response = WebRegistrationJob.new({ payload: user_payload }.to_json).perform
  end
end
