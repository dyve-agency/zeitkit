class Worklog < ActiveRecord::Base
  attr_accessible :client_id, :end_time, :start_time, :user_id

  belongs_to :user
  belongs_to :client

  def duration
    (end_time - start_time).to_i
  end

  def duration_hours
    duration / 1.hour
  end

  def duration_minutes
    duration / 1.minute % 60
  end

  def price
    client.secondly_rate * duration
  end

end
