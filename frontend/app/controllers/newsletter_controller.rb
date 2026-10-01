class NewsletterController < ApplicationController
  before_action :set_email, only: %i[create]

  def create
    redirect_to(home_path,
      notice: "%s: %s" % [I18n.t('newsletter.success'), @email]
    )
  end

  private

  def set_email
    @email = params[:email]
  end
end
