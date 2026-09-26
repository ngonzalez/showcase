class PagesController < ApplicationController
  before_action :set_permitted_params, only: %i[register validate]
  before_action :decode_user_payload, only: %i[register validate]
  before_action :set_plan, only: %i[register]

  attr_accessor :permitted_params
  attr_accessor :user_payload

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
    if permitted_params[:payload].nil?
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

  private

  def set_permitted_params
    @permitted_params = params[:user].permit! if params[:user]
  end

  def decode_user_payload
    @user_payload = JSON.parse(Base64.decode64(permitted_params[:payload]), symbolize_names: true) rescue {}
  end

  def set_plan
    @plan = ["5GB", "10GB"].include?(user_payload[:plan]) ? user_payload[:plan] : "5GB"
  end
end
