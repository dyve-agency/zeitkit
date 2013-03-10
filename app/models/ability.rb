class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    can :manage, [Client, Worklog, Note, Invoice, User, InvoiceDefault, Expense], user_id: user.id
  end
end
