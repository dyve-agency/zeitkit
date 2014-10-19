class WorklogSerializer < ActiveModel::Serializer
  attributes :id, :comment, :hourly_rate, :client_id, :timeframes, :client, :clients

  def comment
    object.summary
  end

  def hourly_rate
    object.hourly_rate.to_f
  end

  def timeframes
    object.timeframes
  end

  def client
    object.client
  end

  def clients
    object.user.clients_and_shared_clients
  end

end
