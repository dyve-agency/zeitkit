class ClientSerializer < ActiveModel::Serializer
  attributes :id, :name, :company_name, :hourly_rate, :hourly_rate_cents, :currency, :user, :credit_block_reason

  def hourly_rate
    object.hourly_rate.to_f
  end

  def credit_block_reason
    object.credit_block_reason.present? ? object.credit_block_reason : ""
  end

end
