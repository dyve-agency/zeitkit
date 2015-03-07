class Team < ActiveRecord::Base
  has_and_belongs_to_many :users
  belongs_to :creator, class_name: "User"

  def created_by? user
    creator.try(:id) == user.try(:id)
  end
end
