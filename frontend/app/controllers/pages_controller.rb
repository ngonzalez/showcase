class PagesController < ApplicationController
  include UserPayloadConcern

  before_action :set_plan, only: %i[register]
  before_action :set_user_payload_encoded, only: %i[validate]
  before_action :set_user_payload, only: %i[validate]
  before_action :require_user_payload, only: %i[validate]
  before_action :set_api_response, only: %i[validate confirmation]

  attr_accessor :user_payload

  attr_accessor :api_response
  helper_method :api_response

  attr_accessor :user_payload_encoded
  helper_method :user_payload_encoded

  def home
    render("pages/home")
  end

  def plans
    render("pages/plans")
  end

  def register
    render("pages/register")
  end

  def validate
    render("pages/validate",
      locals: {
        user: {
          payload: user_payload
        }
      }
    )
  end

  def confirmation
    render("pages/confirmation")
  end

  private

  def set_api_response
    @api_response = JSON.parse(params[:api_response])
  rescue StandardError => exception
    Rails.logger.error(exception)
    raise Error::Http::InvalidResponse
  end

  def set_user_payload_encoded
    @user_payload_encoded = params.dig(:user, :payload)
  end

  def set_user_payload
    @user_payload = decrypt_user_payload(user_payload_encoded)
  end

  def require_user_payload
    redirect_to(register_path) if user_payload.nil?
  end

  def default_web_config_plan
    WEB_CONFIG.detect { |web_config| web_config[:default] }[:name]
  end

  def web_config_plans
    WEB_CONFIG.map { |web_config| web_config[:name] }
  end

  def set_plan
    @plan = web_config_plans.include?(params[:plan]) ? params[:plan] : default_web_config_plan
  end
end
