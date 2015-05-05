class ClientSerializer < ActiveModel::Serializer
  attributes :id, :name, :company_name, :hourly_rate, :hourly_rate_cents, :currency, :user, :credit_block_reason

  def hourly_rate
    if object.user == current_user
      object.hourly_rate.to_f
    else
      object.client_shares.where(user_id: current_user.id).first.hourly_rate.to_f
    end
  end

  def credit_block_reason
    object.credit_block_reason.present? ? object.credit_block_reason : ""
  end

end
