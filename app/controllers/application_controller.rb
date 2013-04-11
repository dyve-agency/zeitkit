class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :check_and_set_mac_design
  before_filter :check_auth_token_and_login

  def check_and_set_mac_design
    cookies[:mac_app] = true if params[:mac_app]
  end

  def check_auth_token_and_login
    return unless params[:access_token]
    auto_login(AccessToken.find_by_token(params[:access_token]).user)
  end
end
