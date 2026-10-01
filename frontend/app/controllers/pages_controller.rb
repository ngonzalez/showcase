class PagesController < ApplicationController
  before_action :set_permitted_params, only: %i[register validate confirmation]
  before_action :decode_user_payload, only: %i[register validate confirmation]
  before_action :set_plan, only: %i[register]
  before_action :set_user_payload_encoded, only: %i[validate]
  before_action :set_api_response, only: %i[validate confirmation]

  attr_accessor :permitted_params
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
    render("pages/register",
      locals: {
        user: {
          payload: user_payload
        }
      }
    )
  end

  def validate
    if permitted_params.try(:[], :payload).nil?
      redirect_to(register_path)
    else
      render("pages/validate",
        locals: {
          user: {
            payload: user_payload
          }
        }
      )
    end
  end

  def confirmation
    if permitted_params.try(:[], :payload).nil?
      redirect_to(register_path)
    else
      render("pages/confirmation",
        locals: {
          user: {
            payload: user_payload
          }
        }
      )
    end
  end

  private

  def set_api_response
    @api_response = JSON.parse(params[:api_response])
  rescue StandardError => exception
    Rails.logger.error(exception)
    raise Error::Http::InvalidResponse
  end

  def set_permitted_params
    @permitted_params = params[:user].permit! if params[:user]
  end

  def set_user_payload_encoded
    @user_payload_encoded = permitted_params[:payload] rescue nil
  end

  def default_web_config_plan
    WEB_CONFIG.detect { |web_config| web_config[:default] }[:name]
  end

  def web_config_plans
    WEB_CONFIG.map { |web_config| web_config[:name] }
  end

  def set_plan
    @plan = web_config_plans.include?(user_payload[:plan]) ? user_payload[:plan] : default_web_config_plan
  end

  def decode_user_payload
    @user_payload = JSON.parse(Base64.decode64(permitted_params[:payload]), symbolize_names: true) rescue {}
  end
end
