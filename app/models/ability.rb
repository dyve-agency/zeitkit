class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    can :manage, [Client, Worklog, Note, Invoice], user_id: user.id
  end
end
