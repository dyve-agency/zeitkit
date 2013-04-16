class User < ActiveRecord::Base
  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end
  include NilStrings

  attr_accessible :email,
    :password,
    :password_confirmation,
    :name,
    :company_name,
    :zip,
    :street,
    :city,
    :currency,
    :first_name,
    :last_name,
    :authentications_attributes

  has_many :clients
  has_many :worklogs
  has_many :invoices
  has_many :notes
  has_many :expenses
  has_many :products
  has_many :access_tokens, :dependent => :delete_all
  has_many :authentications, :dependent => :destroy

  has_one :temp_worklog_save
  has_one :invoice_default

  before_validation :set_initial_currency!, on: :create
  before_validation :set_email_sent_false!, on: :create

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email, :currency
  validates_uniqueness_of :email

  before_create :get_name_from_api
  after_create :build_invoice_default
  after_create :build_initial_temp_worklog_save
  before_create :get_name_from_api

  scope :paid, where(invoice_id: !nil)
  scope :no_signup_email_sent, where(signup_email_sent: false)
  scope :older_than_30_minutes, lambda {where("created_at <= ?", 30.minutes.ago)}

  def set_temp_password(temp_pw)
    self.password = temp_pw
    self.password_confirmation = temp_pw
  end

  def build_initial_temp_worklog_save
    temp_save = TempWorklogSave.new(user_id: self.id)
    temp_save.save
  end

  def string_fields_to_nil
    [:company_name, :zip, :street, :city]
  end

  def build_invoice_default
    id = InvoiceDefault.new(user_id: self.id)
    id.save
  end


  def unpaid_worklogs_by_client
    unpaid = []
    clients.each do |client|
      total = Worklog.unpaid.where(client_id: client.id).sum(:total_cents)
      next if total == 0
      unpaid.push({client: client.name,
        total: Money.new(total, currency)
      })
    end
    unpaid
  end

  def unpaid_by_client
    unpaid = []
    clients.each do |client|
      total = Worklog.unpaid.where(client_id: client.id).sum(:total_cents)
      total += Expense.unpaid.where(client_id: client.id).sum(:total_cents)
      next if total == 0
      unpaid.push({client: client.name,
        total: Money.new(total, currency)
      })
    end
    unpaid
  end

  def currency
    Money::Currency.new read_attribute(:currency)
  end

  def contact_info_entered?
    company_name && street && city && zip
  end

  def set_initial_currency!
    self.currency = Money.default_currency.iso_code.to_s
  end

  def set_email_sent_false!
    self.signup_email_sent = false
    true
  end

  def total_all_invoices
    Money.new invoices.sum(:total_cents), currency
  end

  def self.email_new_users
    self.no_signup_email_sent.older_than_30_minutes.each do |user|
      begin
        UserMailer.signup_email(user).deliver
      rescue
      ensure
        user.signup_email_sent = true
        user.save
      end
    end
  end

  # Attempt to get the name from the Fullcontact API
  # NOTE: This absolutely has to always return true because it is used in
  #       a before_create. If it returns false a rollback will be issued
  #       and the User will not have been created!
  def get_name_from_api
    if Rails.env.test? || Rails.env.development?
      true
    else
      begin
        person = FullContact.person(email: email)
      rescue
        person = nil
      ensure
        return true if (!person || person.status != 200 || !person.contact_info || !person.contact_info.given_name || person.contact_info.given_name.length == 0)
        self.first_name = person.contact_info.given_name
        self.last_name = person.contact_info.family_name
        person
        true
      end
    end
  end
end
