class Kpi
  extend  ActiveModel::Naming
  extend  ActiveModel::Translation
  include ActiveModel::Validations
  include ActiveModel::Conversion

  attr_accessor :client_id, :user_id

  def initialize(params={})
    params.each do |attr, value|
      self.public_send("#{attr}=", value)
    end if params

    super()
  end

  def persisted?
    false
  end

  def new_record?
    true
  end

  def can_display_data?
    false
  end
end
