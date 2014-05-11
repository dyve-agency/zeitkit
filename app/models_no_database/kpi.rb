class Kpi
  extend  ActiveModel::Naming
  extend  ActiveModel::Translation
  include ActiveModel::Validations
  include ActiveModel::Conversion

  attr_accessor :client_id, :user_id, :user_data, :requester

  def initialize(params={})
    params.each do |attr, value|
      self.public_send("#{attr}=", value)
    end if params

    super()

    self.user_data = []
  end

  def persisted?
    false
  end

  def new_record?
    true
  end

  def can_display_data?
    user_data.present?
  end

  def generate_user_data
    # FIXME add some security
    self.user_data = Worklog.where(user_id: user_id.to_i, client_id: client_id.to_i).includes(:client, :user).group_by{|wl| wl.user }
  end
end
