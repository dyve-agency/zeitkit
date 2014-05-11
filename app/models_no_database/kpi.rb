class Kpi
  extend  ActiveModel::Naming
  extend  ActiveModel::Translation
  include ActiveModel::Validations
  include ActiveModel::Conversion

  ALLOWED_GROUPING_OPTIONS = %w[day week month year]

  attr_accessor :client_ids, :user_ids, :user_data, :requester, :group_data_by

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

    if !ALLOWED_GROUPING_OPTIONS.include?(group_data_by)
      self.group_data_by = "day"
    end

    set_client_ids
    set_user_ids
  end

  def persisted?
    false
  end

  def new_record?
    true
  end

  def can_display_data?
    client_ids.present? && user_ids.present?
  end

  def set_client_ids
    converted_client_ids = client_ids.select{|id| id.present? }.map(&:to_i)
    if converted_client_ids.blank? && requester.present?
      converted_client_ids = requester.clients.map(&:id)
    end
    self.client_ids = converted_client_ids
  end

  def set_user_ids
    converted_user_ids = user_ids.select{|id| id.present? }.map(&:to_i)
    if converted_user_ids.blank? && requester.present?
      converted_user_ids = requester.added_team_members.map(&:id)
    end
    self.user_ids = converted_user_ids
  end

  def generate_user_data
    temp = Worklog.where(user_id: user_ids, client_id: client_ids).includes(:client, :user).group_by{|wl| wl.user }
    self.user_data = temp
  end

  def all_worklogs_for_criteria
    Worklog.where(user_id: user_ids, client_id: client_ids)
  end

  def worklog_earnings_grouped
    all_worklogs_for_criteria.send("group_by_#{group_data_by}", :end_time, {format: format_string_for_display}).sum("hourly_rate_cents / 100")
  end

  def worklogs_grouped_by
    user_ids.map do |user_id|
      OpenStruct.new(
        user: User.find(user_id),
        data: Worklog.where(user_id: user_id).
          where(client_id: client_ids).
          send("group_by_#{group_data_by}", :end_time).
          sum("end_time - start_time")
      )
    end
  end

  def group_date_i18n_format
    "kpi_#{group_data_by}".to_sym
  end

  def format_string_for_display
    translations = I18n.backend.send(:translations)
    translations[:en][:time][:formats][group_date_i18n_format]
  end
end
