class Kpi
  extend  ActiveModel::Naming
  extend  ActiveModel::Translation
  include ActiveModel::Validations
  include ActiveModel::Conversion

  attr_accessor :client_ids, :user_ids, :user_data, :requester

  def initialize(params={})
    params.each do |attr, value|
      self.public_send("#{attr}=", value)
    end if params

    super()

    if client_ids.nil?
      self.client_ids = []
    end

    if user_ids.nil?
      self.user_ids = []
    end
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
    converted_client_ids = client_ids.select{|id| id.present? }.map(&:to_i)
    if converted_client_ids.blank?
      converted_client_ids = requester.clients.map(&:id)
    end

    converted_user_ids   = user_ids.select{|id| id.present? }.map(&:to_i)
    if converted_user_ids.blank?
      converted_user_ids = requester.added_team_members.map(&:id)
    end

    temp = Worklog.where(user_id: converted_user_ids, client_id: converted_client_ids).includes(:client, :user).group_by{|wl| wl.user }

    self.user_data = temp
  end
end
