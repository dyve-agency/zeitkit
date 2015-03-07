class TeamUser < ActiveRecord::Base
  STATES = %w[confirmed pending]
  belongs_to :team
  belongs_to :user
  attr_accessor :invite_username
  validates :state, inclusion: {in: STATES }
end
