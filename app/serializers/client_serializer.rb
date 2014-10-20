class ClientSerializer < ActiveModel::Serializer
  attributes :id, :name, :company_name, :hourly_rate, :hourly_rate_cents

  def hourly_rate
    object.hourly_rate.to_f
  end
end
