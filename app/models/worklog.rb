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
    :paid

  belongs_to :user
  belongs_to :client
  belongs_to :invoice

  validates :user, :client, :start_time, :end_time, presence: true

  validate :end_time_greater_than_start_time
  validate :duration_less_than_a_year

  before_validation :ensure_paid_not_nil
  before_validation :set_hourly_rate, on: :create
  before_save :set_total
  after_create :drop_start_time_save

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
    %w(Client_name Start_time End_time Hours Minutes Hourly_rate Total_cents Summary Paid)
  end

  def array_data_to_export
    [client.name,
    I18n.localize(start_time),
    I18n.localize(end_time),
    duration_hours,
    duration_minutes,
    hourly_rate,
    total_cents,
    summary,
    yes_or_no_boolean(paid)]
  end

  def yes_or_no_boolean(boolean_var)
    boolean_var ? "Yes" : "No"
  end

  def duration
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
    end_time > start_time
  end

  def toggle_paid
    paid ? self.paid = false : self.paid = true
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

  def drop_start_time_save
    if user.start_time_save
      user.start_time_save.destroy
    end
  end

end
