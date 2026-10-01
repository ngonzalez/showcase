class RegistrationBaseController < ApplicationController
  before_action :set_permitted_params, only: %i[create]
  before_action :set_user_payload, only: %i[create]

  attr_accessor :permitted_params
  attr_accessor :user_payload

  private

  def set_permitted_params
    @permitted_params = params[:user].permit! if params[:user]
  end

  def set_user_payload
    @user_payload = Base64.encode64(params[:user].to_json) rescue {}
  end
end
