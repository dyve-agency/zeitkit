class TeamAggregator
  RANGE_VALUES = %w[this_month last_month this_week last_week this_year last_year]
  include Virtus.model
  include ActiveModel::Model
  attribute :team
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

  def results
    team.confirmed_users.map do |user|
      result_data = generate_result_data user
      ResultEntry.new(result_data)
    end
  end

  def sorted_results
    results.sort_by {|r| r.total }.reverse
  end

  def generate_result_data user
    use_worklogs = worklogs user
    {
      username: user.username,
      seconds_worked: use_worklogs.where(team_id: team).map(&:duration).inject(:+) || 0,
      total_cents: use_worklogs.where(team_id: team).map(&:total_cents).inject(:+) || 0,
      currency: (user.currency || Money.default_currency)
    }
  end

  def worklogs user
    user.worklogs.joins(:timeframes).
      where("DATE(timeframes.ended) >= ?", start_date.to_date).
      where("DATE(timeframes.started) <= ?", end_date.to_date).
      preload(:timeframes).
      group("worklogs.id")
  end

  class ResultEntry
    include Virtus.model
    attribute :username
    attribute :seconds_worked
    attribute :total_cents
    attribute :currency

    def total
      Money.new total_cents, currency
    end

    def hours_formatted
      minutes = (seconds_worked / 60) % 60
      hours = seconds_worked / (60 * 60)
      format("%02dH:%02dM", hours, minutes) #=> "01:00:00"
    end

  end


end
