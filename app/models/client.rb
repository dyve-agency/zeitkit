class Client < ActiveRecord::Base
  attr_accessible :hourly_rate, :name

  belongs_to :user
  has_many :worklogs

  validates :user, :name, :hourly_rate, presence: true

  # TODO validate only one client with same name per user.

end
