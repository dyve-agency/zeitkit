class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :require_login
  before_filter :check_and_set_mac_design

  def check_and_set_mac_design
    cookies[:mac_app] = true if params[:mac_app]
  end

  def not_authenticated
    redirect_to login_url, :alert => "Please first login to access this page."
  end

end
