class Worklog < ActiveRecord::Base
  include HourlyRateHelper

  include TotalHelper
  total_and_currency_for attribute_name: :total, cents_attribute: :total_cents

  attr_accessible :client_id,
    :end_time,
    :start_time,
    :user_id,
    :hourly_rate,
    :hourly_rate_cents,
    :total,
    :summary,
    :from_date,
    :from_time,
    :to_date,
    :to_time,
    :team_id,
    :timeframes

  attr_accessor :from_date,
    :from_time,
    :to_date,
    :to_time

  default_scope -> { where(deleted_at: nil) }

  def self.deleted
    self.unscoped.where('deleted_at IS NOT NULL')
  end

  belongs_to :user
  belongs_to :client
  belongs_to :client_share
  belongs_to :invoice
  belongs_to :team
  has_many :timeframes

  validates :user, :client, presence: true


  before_validation :set_client_share

  after_create :email_user_of_shared_client_worklog

  scope :paid, -> { where.not(invoice_id: nil) }
  scope :unpaid, -> { where(invoice_id: nil) }
  scope :no_invoice, -> { where(invoice_id: nil) }
  scope :oldest_first, -> { order("end_time ASC") }
  scope :today, ->(scope) { where(id: scope.joins(:timeframes).having("MAX(timeframes.ended) >= ?", Time.zone.now.midnight).group("worklogs.id")) }
  scope :this_week, ->(scope) { where(id: scope.joins(:timeframes).having("MAX(timeframes.ended) BETWEEN ? AND ?", Time.zone.now.beginning_of_week, Time.zone.now).group("worklogs.id")) }
  scope :this_month, ->(scope) { where(id: scope.joins(:timeframes).having("MAX(timeframes.ended) BETWEEN ? AND ?", Time.zone.now.beginning_of_month, Time.zone.now).group("worklogs.id")) }
  scope :older_than_this_month, ->(scope) { where(id: scope.joins(:timeframes).having("MAX(timeframes.ended) < ?", Time.zone.now.beginning_of_month).group("worklogs.id")) }
  scope :last_month, ->(scope) { where(id: scope.joins(:timeframes).having("MAX(timeframes.ended) BETWEEN ? AND ?", (Time.zone.now.beginning_of_month - 1.month), Time.zone.now.beginning_of_month).group("worklogs.id")) }

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

  def self.updated_since(unixtimestamp)
    self.unscoped.where("updated_at >= ?", Time.at(unixtimestamp.to_i).to_datetime)
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

  def invoiced?
    invoice_id
  end

  def yes_or_no_boolean(boolean_var)
    boolean_var ? "Yes" : "No"
  end

  def duration
    timeframes.map(&:duration).inject(:+) || 0
  end

  def duration_hours
    self.class.hours_from_seconds duration
  end

  def duration_minutes
    self.class.remaining_minutes_from_seconds duration
  end

  def title
    "#{end_time.strftime("%d.%m.%Y")} - #{duration_hours.to_s}h:#{duration_minutes.to_s}min. #{total.to_s}#{total.currency.symbol}"
  end

  def invoice_title(invoice)
    "Work: #{end_time.strftime("%d.%m.%Y")} - #{duration_hours.to_s}h:#{duration_minutes.to_s}min x #{hourly_rate}#{hourly_rate.currency.symbol}"
  end

  def start_time
    timeframes.order("started ASC").limit(1).first.started
  end

  def end_time
    timeframes.order("ended desc").limit(1).first.ended
  end

  # returns the client share that links this worklog to the original user and
  # the user that owns the worklog.
  def client_share
    client.client_shares.where(user_id: self.user_id).first
  end

  def client_subcontractor_name_or_username
    client_share.try(:subcontractor_shown_name).present? ? client_share.subcontractor_shown_name : user.username
  end

  def created_for_shared_client?
    # We own the client
    if user.clients.where(id: client_id).any?
      false
    else
      true
    end
  end

  def created_for_user
    if created_for_shared_client?
      client.user
    else
      user
    end
  end

  def email_user_of_shared_client_worklog
    if created_for_shared_client? && client.email_when_team_adds_worklog
      begin
        WorklogMailer.worklog_for_shared_client_created(self).deliver
      rescue => e
        Rails.logger.fatal "Could not deliver worklog message: #{e.message.to_s} - #{e.backtrace.join("\n")}"
      end
    end
    true
  end


  def not_set_by_user
    # This check only works for new records, as the hourly rate is persisted
    # after.
    return if !new_record?
    hourly_rate.cents == 0
  end

  # Freshly calculate the total from each timeframe of the worklog.
  def calc_total
    duration.to_f / 1.hour.to_f * hourly_rate.to_f
  end

  def set_client_share
    if user && client && created_for_shared_client?
      self.client_share = user.client_shares.where(client_id: self.client_id).first
    end
    true
  end

end
