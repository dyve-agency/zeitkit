class User < ActiveRecord::Base
  authenticates_with_sorcery!

  attr_accessible :email, :password, :password_confirmation

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email

  has_many :clients
  has_many :worklogs

  has_one :start_time_save

  def set_temp_password(temp_pw)
    self.password = temp_pw
    self.password_confirmation = temp_pw
  end

end
