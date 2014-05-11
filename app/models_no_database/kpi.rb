class Kpi

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :client_id, :user_id

  def persisted?
    false
  end

  def new_record?
    true
  end

end
