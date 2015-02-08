class TeamAggregator
  RANGE_VALUES = %w[this_month last_month this_week last_week this_year last_year]
  include Virtus.model
  include ActiveModel::Model
  attribute :team
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

  def results
    team.users.map do |user|
      result_data = generate_result_data user
      ResultEntry.new(result_data)
    end
  end

  def generate_result_data user
    {
      username: user.username,
      seconds_worked: 9199,
      total_cents: 1000
    }
  end

  class ResultEntry
    include Virtus.model
    attribute :username
    attribute :seconds_worked
    attribute :total_cents

    def total
      total_cents
    end

    def hours_formatted
      seconds_worked
    end
  end


end
