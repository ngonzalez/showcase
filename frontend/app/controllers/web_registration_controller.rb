class WebRegistrationController < RegistrationBaseController
  before_action :create_job, only: %i[create]
  before_action :set_api_response, only: %i[create]

  attr_accessor :api_response

  def create
    redirect_to(confirmation_path(api_response: api_response, user: { payload: user_payload }))
  end

  private
  
  def create_job
    @web_registration_response = WebRegistrationJob.new({ payload: user_payload }.to_json).perform
  end

  def set_api_response
    @api_response = @web_registration_response.body
  end
end
