class Worklog < ActiveRecord::Base
  attr_accessible :client_id,
    :end_time,
    :start_time,
    :user_id,
    :hourly_rate,
    :price,
    :summary,
    :paid

  belongs_to :user
  belongs_to :client

  validates :user, :client, :start_time, :end_time, presence: true

  validate :end_time_greater_than_start_time
  validate :duration_less_than_a_year

  before_validation :ensure_paid_not_nil
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

  def end_time_ok
    end_time > start_time
  end

  # Active record callbacks #

  def set_hourly_rate
    self.hourly_rate = client.hourly_rate
  end

  def set_price
    self.price = self.calc_price.round(2)
  end

  def ensure_paid_not_nil
    self.paid = false if paid.nil?
  end

  # Validations #
  def duration_less_than_a_year
    if duration > 1.year && end_time_ok
      errors.add(:start_time, "Must be smaller than a year.")
      errors.add(:end_time, "Must be smaller than a year.")
    end
  end

  def end_time_greater_than_start_time
    if !end_time_ok
      errors.add(:end_time, "Must be greater than start time.")
    end
  end
end
