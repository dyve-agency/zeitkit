class TempWorklogSave < ActiveRecord::Base
  attr_accessible :start_time, :user_id, :start_time, :end_time, :summary, :client_id
  belongs_to :user

  validates :user_id, uniqueness: { message: "You can only have one start time save." }
end
