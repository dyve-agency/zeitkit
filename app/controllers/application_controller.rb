class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :check_and_set_mac_design

  def check_and_set_mac_design
    cookies[:mac_app] = true if params[:mac_app]
  end
end
