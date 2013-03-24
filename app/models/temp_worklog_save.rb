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

  def restoreable_options
    hash = attributes
    hash.delete("user_id")
    hash.delete("created_at")
    hash.delete("id")
    hash.delete("updated_at")
    hash.delete("show_user")
    hash
  end
end
