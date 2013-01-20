class Worklog < ActiveRecord::Base
  attr_accessible :client_id,
    :end_time,
    :start_time,
    :user_id,
    :hourly_rate,
    :price


  belongs_to :user
  belongs_to :client

  before_save :set_hourly_rate, on: :create
  before_save :set_price

  def duration
    (end_time - start_time).to_i
  end

  def duration_hours
    duration / 1.hour
  end

  def duration_minutes
    duration / 1.minute % 60
  end

  def calc_price
    rate = secondly_rate(hourly_rate)
    return if !rate
    rate * duration
  end

  def secondly_rate(hour_rate)
    return if !hour_rate
    hour_rate / 3600
  end

  # Active record callbacks #

  def set_hourly_rate
    self.hourly_rate = client.hourly_rate
  end

  def set_price
    self.price = self.calc_price.round(2)
  end

end
