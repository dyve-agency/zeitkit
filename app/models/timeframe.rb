class Timeframe < ActiveRecord::Base
  attr_accessible :ended, :started, :worklog_id
  belongs_to :worklog
  validates :ended, :started, presence: true
  validate :end_time_greater_than_start_time
  validate :duration_less_than_a_year

  def duration
    return if ended.blank? || started.blank?
    (ended - started).to_i
  end

  # Validations #

  def duration_less_than_a_year
    if duration && duration > 1.year
      errors.add :base, "Must be smaller than a year"
    end
  end

  def end_time_greater_than_start_time
    if ended && started && started >= ended
      errors.add :ended, "Must be greater than the start."
    end
  end
end
