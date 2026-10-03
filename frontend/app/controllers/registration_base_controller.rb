class RegistrationBaseController < ApplicationController
  before_action :set_permitted_params, only: %i[create]
  before_action :require_permitted_params, only: %i[create]
  before_action :set_user_payload, only: %i[create]

  attr_accessor :permitted_params
  attr_accessor :user_payload

  private

  def set_permitted_params
    @permitted_params = params[:user].permit! if params[:user]
  end

  def require_permitted_params
    redirect_to(register_path) if permitted_params.blank?
  end

  def set_user_payload
    @user_payload = Base64.strict_encode64(permitted_params.to_h.to_json)
  end

  def web_registration_client
    WebRegistrationClient.new
  end
end
