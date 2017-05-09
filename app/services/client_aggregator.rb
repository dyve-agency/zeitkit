class ClientAggregator

  RANGE_VALUES = %w[this_month last_month this_week last_week this_year last_year]
  include Virtus.model
  include ActiveModel::Model
  attribute :client
  attribute :base_user

  # Attributes for date filtering
  attribute :start_date
  attribute :end_date
  attribute :specific_range

  def aggregate
    set_dates if specific_range.present?
  end

  def specific_range=(new_val)
    if RANGE_VALUES.include?(new_val)
      super new_val
    end
  end

  def start_date=(new_val)
    result = nil
    begin
      result = new_val.is_a?(String) ? Date.parse(new_val) : new_val
    rescue
    end
    super result
  end

  def end_date=(new_val)
    result = nil
    begin
      result = new_val.is_a?(String) ? Date.parse(new_val) : new_val
    rescue
    end
    super result
  end

  def sorted_results
    results.sort_by {|r| r.started }.reverse
  end

  private

  def set_dates
    case specific_range
    when "this_week"
      self.start_date = Time.now.beginning_of_week
      self.end_date = Time.now
    when "last_week"
      self.start_date = 1.week.ago.beginning_of_week
      self.end_date = 1.week.ago.end_of_week
    when "this_month"
      self.start_date = Time.now.beginning_of_month
      self.end_date = Time.now
    when "last_month"
      self.start_date = 1.month.ago.beginning_of_month
      self.end_date = 1.month.ago.end_of_month
    when "this_year"
      self.start_date = Time.now.beginning_of_year
      self.end_date = Time.now
    when "last_year"
      self.start_date = 1.year.ago.beginning_of_year
      self.end_date = 1.year.ago.end_of_year
    else
    end
  end

  def results
    @mapped_results ||= worklogs.map do |worklog|
      result_data = generate_result_data worklog
      ResultEntry.new(result_data)
    end
  end

  def generate_result_data worklog
    {
      username: username_for_worklog(worklog),
      seconds_worked: worklog.duration,
      total_cents: worklog.total_cents,
      currency: (worklog.user.currency || Money.default_currency),
      worklog_id: worklog.id,
      worklog_summary: worklog.summary,
      started: worklog.start_time,
      ended: worklog.end_time,
      timeframes: worklog.timeframes
    }
  end

  def worklogs
    client.worklogs.joins(:timeframes).
      where("timeframes.ended >= ?", start_date.to_datetime).
      where("timeframes.started <= ?", end_date.to_datetime).
      preload(:timeframes, :client_share, :user).
      group("worklogs.id")
  end

  def total_time
    seconds = results.map(&:seconds_worked).inject(:+) || 0 #results.map{ |res| res.seconds_worked }
    minutes = (seconds / 60) % 60
    hours = seconds / (60 * 60)
    format("%02dH:%02dM", hours, minutes) #=> "01:00:00"
  end

  def total_costs
    cents = results.map(&:total_cents).inject(:+) || 0
    Money.new cents, client.currency
  end

  # returns the username to be used in the aggregration
  def username_for_worklog(worklog)
    return worklog.user.username if worklog.client_share.blank?
    if worklog.client_share.works_as_subcontractor
      worklog.client_share.subcontractor_shown_name
    else
      worklog.user.username
    end
  end

  class ResultEntry
    include Virtus.model
    attribute :username
    attribute :seconds_worked
    attribute :total_cents
    attribute :currency
    attribute :worklog_id
    attribute :worklog_summary
    attribute :started
    attribute :ended
    attribute :timeframes

    def started_formatted
      I18n.l started, format: :short
    end

    def ended_formatted
      I18n.l ended, format: :short
    end

    def total
      Money.new total_cents, currency
    end

    def hours_formatted
      minutes = (seconds_worked / 60) % 60
      hours = seconds_worked / (60 * 60)
      format("%02dH:%02dM", hours, minutes) #=> "01:00:00"
    end

    def seconds_to_hours
      seconds_worked / (60 * 60)
    end

    def seconds_to_minutes
      (seconds_worked / 60) % 60
    end

  end
end
