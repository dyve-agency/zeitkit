require 'ostruct'
class DevController < ApplicationController
  skip_before_filter :require_login
  before_filter :do_not_execute_in_production!
  skip_authorization_check

  def impersonate
    user = User.find(params.require(:user_id))
    auto_login(user)
    redirect_to "/"
  end

  def locales
  end

  def access_denied
    raise CanCan::AccessDenied
  end

  def flash_messages
    flash[:alert]        = "I am a `alert` flash message"
    flash[:error]        = "I am a `error` flash message"
    flash[:notice]       = "I am a `notice` flash message"
    flash[:non_existent] = "I am a `not_existant` flash message"
  end

  def send_test_mail
    user = OpenStruct.new(email: 'iamuser@railsblank.app')
    TestMailer.async_deliver(:testing, user)
    redirect_to :back
  end

  private

  def do_not_execute_in_production!
    raise ActiveRecord::RecordNotFound if Rails.env.production?
  end
end

