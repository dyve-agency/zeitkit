class Timeframe < ActiveRecord::Base
  attr_accessible :ended, :started, :worklog_id
  belongs_to :worklog
  validates :ended, :started, presence: true
  validate :end_time_greater_than_start_time
  validate :duration_less_than_a_year

  # Validations #
  def multi_errors_add(attributes, message)
    attributes.each do |attri|
      errors.add(attri, message)
    end
  end

  def duration
    return if ended.blank? || started.blank?
    (ended - started).to_i
  end


  def duration_less_than_a_year
    if duration && duration > 1.year
      multi_errors_add([:started, :ended], "Must be smaller than a year")
    end
  end

  def end_time_greater_than_start_time
    if ended && ended >= started
      multi_errors_add([:ended], "Must be greater than the start.")
    end
  end
end
