class Client < ActiveRecord::Base
  attr_accessible :hourly_rate, :name

  belongs_to :user
  has_many :worklogs

  def secondly_rate
    hourly_rate / 3600
  end
end
