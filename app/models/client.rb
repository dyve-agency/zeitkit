class Client < ActiveRecord::Base
  attr_accessible :hourly_rate, :name

  belongs_to :user
  has_many :worklogs

end
