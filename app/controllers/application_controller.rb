class ApplicationController < ActionController::Base
  helper Starburst::AnnouncementsHelper
  protect_from_forgery

  around_filter :set_time_zone
  before_filter :set_holidays_and_business_hours
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

  def set_holidays_and_business_hours
    if current_user.present? && current_user.holiday_setting.use_holidays
      BusinessTime::Config.work_week = current_user.business_hours.map(&:workday).map(&:to_sym)
      BusinessTime::Config.work_hours = current_user.business_hours.map do |bh|
        [bh.workday.to_sym, [bh.start_time.strftime("%H:%M"), bh.end_time.strftime("%H:%M")]]
      end.to_h
      BusinessTime::Config.holidays = current_user.holidays.map(&:day)

      if current_user.holiday_setting.holiday_region.present?
        Holidays.between(Date.civil(2013, 1, 1), Date.today, current_user.holiday_setting.holiday_region.to_sym, :observed).map do |holiday|
          BusinessTime::Config.holidays << holiday[:date]
        end
      end
    end
  end

  def init_gon
    gon.current_user_id = current_user.id
  end

  # ActiveModel serializer, skip the root node.
  def default_serializer_options
    { root: false }
  end

end
