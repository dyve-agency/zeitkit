class WorklogForm
  include Virtus.model
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attribute :worklog, Worklog
  attribute :user, User
  attribute :timeframes, Array
  attribute :hourly_rate, Numeric
  attribute :comment, String, default: ""
  attribute :client_id, Numeric
  attribute :client, Client
  attribute :total, Numeric
  attribute :team_id, Numeric
  attribute :team, Team

  validates :user, presence: true
  validates :client, presence: true
  validates :hourly_rate, numericality: {greater_than: 0}
  validates :total, numericality: {greater_than: 0}, allow_nil: true
  validates :comment, presence: true
  validate :timeframes_validator

  def self.new_from_params(params, user: nil, worklog: nil, team: nil)
    obj = new(params)
    obj.team = team
    obj.user = user
    obj.worklog = worklog
    obj
  end

  def save
    set_correct_hourly_rate
    if valid?
      wl = worklog || to_worklog
      wl = assign_new_attributes(wl)
      self.worklog = wl
      worklog.save!
    else
      false
    end
  end

  def timeframes=(new_timeframes)
    result = []
    if new_timeframes.is_a? Array
      new_timeframes.each do |tf|
        if tf.is_a? Timeframe
          result << tf
        else
          result << Timeframe.new(tf.except(:id, :created_at, :updated_at))
        end
      end
    else
      result = new_timeframes
    end
    super result
  end

  def client_id=(new_id)
    self.client = Client.where(id: new_id).first
    super new_id
  end

  def team_id=(new_id)
    self.team = Team.where(id: new_id).first
    super new_id
  end

  def assign_new_attributes(use_worklog)
    use_worklog.hourly_rate = Money.new hourly_rate.to_f * 100
    use_worklog.summary     = comment
    use_worklog.user        = user
    use_worklog.team        = team
    use_worklog.client      = client
    use_worklog.team        = team
    use_worklog.timeframes  = timeframes
    use_worklog.total       = Money.new(total&.to_f || use_worklog.calc_total ) * 100
    use_worklog
  end

  def to_worklog
    wl = Worklog.new
    wl
  end

  private

  def timeframes_validator
    if timeframes.blank?
      errors.add :timeframes, "- must be present"
      return
    end

    unless timeframes.all? {|tf| tf.valid? }
      errors.add :timeframes, " - some of the timeframes are not valid"
      tf = timeframes.find {|tf| !tf.valid? }
      # Add first timeframe messages errors.
      errors.add :timeframes, "- #{tf.errors.full_messages_joined}"
    end
  end

  def timeframes_correct_start_end_time?
    timeframes.any? {|tf| t}
  end

  def set_correct_hourly_rate
    return unless user
    return unless client
    share = user.client_shares.where(client_id: client.id).first
    if share
      self.hourly_rate = share.hourly_rate
    end
    true
  end

end
