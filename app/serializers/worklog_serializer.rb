class WorklogSerializer < ActiveModel::Serializer
  attributes :id, :comment, :hourly_rate, :client_id, :team_id, :timeframes, :total

  belongs_to :client
  # belongs_to :team

  def comment
    object.summary
  end

  def hourly_rate
    object.hourly_rate.to_f
  end

  def timeframes
    object.timeframes
  end

  def total
    object.total.to_f
  end

end
