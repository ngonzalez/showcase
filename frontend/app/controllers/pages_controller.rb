class PagesController < ApplicationController
  before_action :set_plan, only: %i[register]

  def home
  end

  def plans
  end

  def register
  end

  def validate
  end

  private

  def set_plan
    @plan = ["5GB", "10GB"].include?(params[:plan]) ? params[:plan] : "5GB"
  end
end
