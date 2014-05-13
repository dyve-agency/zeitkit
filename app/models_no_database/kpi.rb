class Kpi
  extend  ActiveModel::Naming
  extend  ActiveModel::Translation
  include ActiveModel::Validations
  include ActiveModel::Conversion

  ALLOWED_GROUPING_OPTIONS = %w[day week month year]

  attr_accessor :client_ids, :user_ids, :user_data, :requester, :group_data_by, :start_date, :end_date

  def initialize(params={})
    params.each do |attr, value|
      self.public_send("#{attr}=", value)
    end if params

    super()
    set_default_values
  end

  def set_default_values
    if client_ids.nil?
      self.client_ids = []
    end
    if user_ids.nil?
      self.user_ids = []
    end
    self.user_data = []

    if !ALLOWED_GROUPING_OPTIONS.include?(group_data_by)
      self.group_data_by = "week"
    end
    if start_date.blank?
      self.start_date = DateTime.now - 1.month
    end
    if end_date.blank?
      self.end_date = DateTime.now
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
    temp = Worklog.where(user_id: user_ids, client_id: client_ids).
      where("start_time >= ? AND end_time <= ?", start_date, end_date).
      order("start_time DESC").
      includes(:client, :user).group_by{|wl| wl.user }
    self.user_data = temp
  end

  def all_worklogs_for_criteria
    Worklog.where(user_id: user_ids, client_id: client_ids).
      where("start_time >= ? AND end_time <= ?", start_date, end_date)
  end

  def worklog_earnings_grouped
    empty_range = empty_date_range
    queried = all_worklogs_for_criteria.send("group_by_#{group_data_by}", :end_time, {format: format_string_for_display}).sum("hourly_rate_cents / 100")
    queried = Hash[queried.map{|date, val| [DateTime.parse(date).to_i, val]}]
    Hash[empty_range.merge(queried).map{|timestamp, result| [Time.at(timestamp).to_datetime.strftime(format_string_for_display), result]}]
  end

  def worklogs_grouped_by
    user_ids.map do |user_id|
      data = Worklog.where(user_id: user_id).
        where(client_id: client_ids).
        where("start_time >= ? AND end_time <= ?", start_date, end_date).
        send("group_by_#{group_data_by}", :end_time).
        sum("end_time - start_time")

      OpenStruct.new(
        user: User.find(user_id),
        data: merge_data_with_preset_data(data)
      )
    end
  end

  # Expects a hash like {DateTime: value}
  def merge_data_with_preset_data(data)
    empty_range = empty_date_range
    queried = Hash[data.map{|date, val| [date.to_i, val]}]
    Hash[empty_range.merge(queried).map{|timestamp, result| [Time.at(timestamp).to_datetime, result]}].sort_by {|k, v| k }.reverse
  end

  def group_date_i18n_format
    "kpi_#{group_data_by}".to_sym
  end

  def format_string_for_display
    empty_date_range
    translations = I18n.backend.send(:translations)
    translations[:en][:time][:formats][group_date_i18n_format]
  end

  def empty_date_range
    step = 1.send(group_data_by.pluralize)
    result = {}
    ( start_date .. end_date ).step(step) do |time|
      result[time.to_i] = nil
    end
    result
  end
end
