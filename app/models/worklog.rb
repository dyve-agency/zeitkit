class Worklog < ActiveRecord::Base
  include HourlyRateHelper
  include TotalHelper

  include TimeFilter

  attr_accessible :client_id,
    :end_time,
    :start_time,
    :user_id,
    :hourly_rate,
    :total,
    :summary,
    :paid,
    :from_date,
    :from_time,
    :to_date,
    :to_time

  attr_accessor :from_date,
    :from_time,
    :to_date,
    :to_time

  belongs_to :user
  belongs_to :client
  belongs_to :invoice

  validates :user, :client, :start_time, :end_time, presence: true

  validate :end_time_greater_than_start_time
  validate :duration_less_than_a_year

  before_validation :ensure_paid_not_nil
  after_validation :set_hourly_rate, on: :create
  after_validation :set_total

  scope :paid, where(paid: true)
  scope :unpaid, where(paid: false)

  def self.to_csv(worklogs)
    CSV.generate do |csv|
      csv << self.columns_to_export
      worklogs.each do |worklog|
        csv << worklog.array_data_to_export
      end
    end
  end

  def self.range_duration_seconds(worklogs)
    return 0 if worklogs.empty?
    sum_start = worklogs.map{|w| w.start_time.to_i}.reduce(:+)
    sum_end = worklogs.map{|w| w.end_time.to_i}.reduce(:+)
    sum_end - sum_start
  end

  def self.hours_from_seconds(seconds)
    seconds / 1.hour
  end

  def self.remaining_minutes_from_seconds(seconds)
    seconds / 1.minute % 60
  end

  def self.columns_to_export
    ["Client", "Start time", "End time", "Hours", "Minutes", "Hourly Rate", "Total", "Summary"]
  end

  def array_data_to_export
    [client.name,
    I18n.localize(start_time),
    I18n.localize(end_time),
    duration_hours,
    duration_minutes,
    hourly_rate,
    total.to_s,
    summary]
  end

  def yes_or_no_boolean(boolean_var)
    boolean_var ? "Yes" : "No"
  end

  def duration
    return if !end_time || !start_time
    (end_time - start_time).to_i
  end

  def duration_hours
    self.class.hours_from_seconds duration
  end

  def duration_minutes
    self.class.remaining_minutes_from_seconds duration
  end

  def calc_total
    Money.new cent_rate_per_second * duration, currency
  end

  def cent_rate_per_second
    hourly_rate_cents.to_f / 3600
  end

  def end_time_ok
    return if !end_time || !start_time
    end_time > start_time
  end

  def toggle_paid
    paid ? self.paid = false : self.paid = true
  end

  def set_from_to_now!
    self.from_date = Time.zone.now.strftime("%d/%m/%Y")
    self.to_date = Time.zone.now.strftime("%d/%m/%Y")
    self.from_time = Time.zone.now.strftime("%H:%M:%S")
    self.to_time = Time.zone.now.strftime("%H:%M:%S")
  end

  def from_converted
    begin
      date = self.from_date.split("/").reverse.map(&:to_i)
      time = self.from_time.split(":").map(&:to_i)
      from_to_time(date, time)
    rescue
      nil
    end
  end

  def from_to_time(date, time)
    Time.new(date[0], date[1], date[2], time[0], time[1], time[2], Time.zone.formatted_offset)
  end

  def to_converted
    begin
      date = self.to_date.split("/").reverse.map(&:to_i)
      time = self.to_time.split(":").map(&:to_i)
      from_to_time(date, time)
    rescue
      nil
    end
  end

  def set_start_end!
    self.start_time = from_converted
    self.end_time = to_converted
  end

  def restore_based_on_saved_info
    return if !user
    self.class.new(user.temp_worklog_save.restoreable_options)
  end

  # Active record callbacks #

  def set_hourly_rate
    self.hourly_rate = client.hourly_rate
  end

  def set_total
    self.total = self.calc_total
  end

  def ensure_paid_not_nil
    self.paid = false if paid.nil?
    true
  end

  # Validations #
  def multi_errors_add(attributes, message)
    attributes.each do |attri|
      errors.add(attri, message)
    end
  end

  def duration_less_than_a_year
    if duration && duration > 1.year && end_time_ok
      multi_errors_add([:start_time, :end_time, :from_date, :from_time, :to_time, :to_date], "Must be smaller than a year")
    end
  end

  def end_time_greater_than_start_time
    if !end_time_ok
      multi_errors_add([:end_time, :to_time, :to_date], "Must be greater than the start.")
    end
  end

end
