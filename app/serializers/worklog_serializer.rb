class WorklogSerializer < ActiveModel::Serializer
  attributes :id, :comment, :hourly_rate, :client_id, :timeframes, :client, :clients, :total, :shared_clients

  belongs_to :client

  def comment
    object.summary
  end

  def hourly_rate
    object.hourly_rate.to_f
  end

  def timeframes
    object.timeframes
  end

  def clients
    object.user.clients
  end

  def shared_clients
    object.user.shared_clients
  end

  def total
    object.total.to_f
  end

end
