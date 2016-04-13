class ApplicationController < ActionController::Base
  protect_from_forgery

  around_filter :set_time_zone
  before_filter :require_login, :except => [:not_authenticated]
  before_filter :check_and_set_mac_design
  before_filter :init_gon, if: :current_user

  # FIX issue with rails responding with plain json. See:
  # http://stackoverflow.com/questions/16400639/back-button-chrome-gets-json-instead-of-html-in-play-framework
  before_filter do
    response.headers["Vary"]= "Accept"
  end

  def check_and_set_mac_design
    cookies[:mac_app] = true if params[:mac_app]
  end

  def not_authenticated
    redirect_to root_path, :alert => "Please first login to access this page."
  end

  def set_current_user(object_with_user_attribute)
    object_with_user_attribute.user = current_user
  end

  # Patching the sorcery current user method
  #alias_method :old_current_user, :current_user
  def current_user
    begin
      super.decorate
    rescue
      nil
    end
  end

  def set_time_zone
    old_time_zone = Time.zone
    Time.zone = current_user.time_zone if current_user.try(:time_zone)
    yield
  ensure
    Time.zone = old_time_zone
  end

  def init_gon
    gon.current_user_id = current_user.id
  end

  # ActiveModel serializer, skip the root node.
  def default_serializer_options
    { root: false }
  end

end
