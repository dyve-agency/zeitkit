class ApplicationController < ActionController::Base
  protect_from_forgery

  around_filter :set_time_zone
  before_filter :require_login, :except => [:not_authenticated]
  before_filter :check_and_set_mac_design
  before_filter :init_gon, if: :current_user

  def check_and_set_mac_design
    cookies[:mac_app] = true if params[:mac_app]
  end

  def not_authenticated
    redirect_to root_path, :alert => "Please first login to access this page."
  end

  def set_current_user(object_with_user_attribute)
    object_with_user_attribute.user = current_user
  end

  def set_time_zone
    old_time_zone = Time.zone
    Time.zone = current_user.time_zone if logged_in? && current_user.time_zone
    yield
  ensure
    Time.zone = old_time_zone
  end

  def init_gon
    gon.current_user_id = current_user.id
  end
end
