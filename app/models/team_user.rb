class TeamUser < ActiveRecord::Base
  STATES = %w[confirmed pending]
  belongs_to :team
  belongs_to :user
  attr_accessor :invite_username
  validates :state, inclusion: {in: STATES }
  before_validation :set_initial_state, on: :create

  scope :pending, -> { where(state: "pending") }

  def confirmed?
    state == "confirmed"
  end

private
  def set_initial_state
    self.state = "pending" if state.blank?
  end
end
