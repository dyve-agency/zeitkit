class HolidaySetting < ActiveRecord::Base
  belongs_to :user

  def use_holidays
    read_attribute(:use_holidays) && user.business_hours.present?
  end
end
