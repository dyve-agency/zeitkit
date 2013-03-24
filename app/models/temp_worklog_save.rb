class TempWorklogSave < ActiveRecord::Base
  attr_accessible :user_id,
    :from_date,
    :from_time,
    :to_date,
    :to_time,
    :summary,
    :client_id
  belongs_to :user

  validates :user_id, uniqueness: { message: "You can only have one start time save." }
end
