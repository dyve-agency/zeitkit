class ClientShare < ActiveRecord::Base
  attr_accessible :client_id, :user_id
  belongs_to :client
  belongs_to :user
end
