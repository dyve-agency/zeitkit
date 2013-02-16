class Client < ActiveRecord::Base
  attr_accessible :hourly_rate, :name

  belongs_to :user
  has_many :worklogs
  has_many :notes

  validates :user, :name, :hourly_rate, presence: true
  validates :name, :uniqueness => { :scope => :user_id,
      :message => "You can only have the client once." }

end
