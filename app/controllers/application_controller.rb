class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :require_login
  before_filter :check_and_set_mac_design
  before_filter :check_tutorial

  def check_and_set_mac_design
    cookies[:mac_app] = true if params[:mac_app]
  end

  def not_authenticated
    redirect_to login_url, :alert => "Please first login to access this page."
  end

  def set_current_user(object_with_user_attribute)
    object_with_user_attribute.user = current_user
  end

  def check_tutorial
    if current_user && current_user.show_tutorial?
      @tutorial = Tutorial.new(current_user)
    end
  end

end
