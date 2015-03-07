class TeamInviteForm
  include Virtus.model
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  attribute :team_id
  attribute :username
  attribute :inviter

  validate :inviter, :team, :user, presence: true
  validate :team_must_belong_to_inviter
  validate :user_must_exist
  validate :user_may_not_be_in_team_already

  def save
    model = TeamUser.new
    model.user_id = user.id
    model.team_id = team.id
    model.state = "pending"
    model.save!
  end

  def persisted?
    false
  end

  def user
    @user ||= User.where(username: username).first
  end

  def team
    @team ||= Team.where(id: team_id).first
  end

private
  def team_must_belong_to_inviter
    if team.blank? || inviter.blank?
      return true
    end
    if inviter.team_ids.include? team.id
      true
    else
      errors.add :base, "Team could not be found"
    end
  end

  def user_must_exist
    if user.blank?
      errors.add :base, "Username could not be found"
    end
  end

  def user_may_not_be_in_team_already
    return true if user.blank? || team.blank?
    if team.user_ids.include? user.id
      errors.add :base, "User already in team"
    end
  end

end
