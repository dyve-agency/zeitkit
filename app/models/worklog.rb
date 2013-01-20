class Worklog < ActiveRecord::Base
  attr_accessible :client_id, :end, :start, :user_id

  belongs_to :user
  belongs_to :client
end
