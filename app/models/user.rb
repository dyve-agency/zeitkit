class User < ActiveRecord::Base
  authenticates_with_sorcery!
  include NilStrings

  attr_accessible :email,
    :password,
    :password_confirmation,
    :name,
    :company_name,
    :zip,
    :street,
    :city

  has_many :clients
  has_many :worklogs
  has_many :invoices
  has_many :notes

  has_one :start_time_save
  has_one :invoice_default

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email

  after_create :build_invoice_default

  def set_temp_password(temp_pw)
    self.password = temp_pw
    self.password_confirmation = temp_pw
  end

  def check_or_build_start_time
    # if there is a start time save return in
    if start_time_save
      start_time_save
    else
      build_start_time_save(start_time: Time.now).save
      nil
    end
  end

  def string_fields_to_nil
    [:company_name, :zip, :street, :city]
  end

  def build_invoice_default
    self.build_invoice_default.save
  end

end
