class Team < ActiveRecord::Base
  has_many :users, through: :team_users
  has_many :team_users
  belongs_to :creator, class_name: "User"

  attr_accessible :name
  validates :name, presence: true
  validates :creator, presence: true, on: :create

  def created_by? user
    creator.try(:id) == user.try(:id)
  end

  def confirmed_users
    users.where("team_users.state = ?", "confirmed")
  end
end
