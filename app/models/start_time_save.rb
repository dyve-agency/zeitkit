class StartTimeSave < ActiveRecord::Base
  attr_accessible :start_time, :user_id
  belongs_to :user

  validates :user_id, uniqueness: { message: "You can only have one start time save." }
end
