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
    :authentications_attributes,
    :time_zone,
    :first_name,
    :last_name,
    :username

  has_many :clients
  has_many :worklogs
  has_many :invoices
  has_many :notes
  has_many :expenses
  has_many :products
  has_many :access_tokens, :dependent => :delete_all
  has_many :authentications, :dependent => :destroy
  has_many :client_shares, dependent: :destroy
  has_many :teams, through: :team_users
  has_many :team_users

  has_one :temp_worklog_save
  has_one :invoice_default

  before_validation :set_initial_currency!, on: :create
  before_validation :set_email_sent_false!, on: :create

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email, :currency
  validates_uniqueness_of :email
  validates :email, email_format: { message: 'address is not of a valid format' }
  validates :time_zone, # allows empty timezone. falls back to default timezone
    inclusion: { in: ActiveSupport::TimeZone.all.map(&:name) },
    unless: Proc.new { |u| u.time_zone.blank? }
  validates :username, presence: true, uniqueness: true

  before_validation :set_temp_username, on: :create
  before_save :update_after_demo_conversion
  before_create :get_name_from_api
  after_create :build_invoice_default
  after_create :build_initial_temp_worklog_save

  scope :paid, -> { where(invoice_id: !nil) }
  scope :no_demo_user, -> { where("email NOT LIKE 'demo%@zeitkit.com'") }
  scope :demo_user, -> { where("email LIKE 'demo%@zeitkit.com'") }
  scope :no_signup_email_sent, -> { where(signup_email_sent: false) }
  scope :older_than_30_minutes, -> { where("created_at <= ?", 30.minutes.ago) }

  def self.unused_random_email
    email = nil
    begin
      new_email = "demo#{SecureRandom.hex}@zeitkit.com"
      unless exists?(email: new_email)
        email = new_email
      end
    end while email.blank?
    email
  end

  def self.unused_random_username
    begin
      username = "user#{SecureRandom.hex(6)}"
    end while exists?(username: username)
    username
  end

  def added_team_members
    client_ids = clients.map(&:id)
    ClientShare.where(client_id: client_ids).includes(:user).map(&:user).uniq
  end

  def set_temp_password(temp_pw)
    self.password = temp_pw
    self.password_confirmation = temp_pw
  end

  def build_initial_temp_worklog_save
    temp_save = TempWorklogSave.new(user_id: self.id)
    temp_save.save
  end

  def shared_clients
    Client.where(id: client_shares.map(&:client_id)).map{|c| c.is_shared = true; c}
  end

  def clients_and_shared_clients
    @clients_and_shared ||= Client.where(id: (shared_clients + clients).map(&:id))
  end

  def owns_client?(client)
    return if client.blank?
    clients.where(id: client.id).any?
  end

  def string_fields_to_nil
    [:company_name, :zip, :street, :city]
  end

  def build_invoice_default
    id = InvoiceDefault.new(user_id: self.id)
    id.save
  end

  def demo?
    demo_email?(email)
  end

  def demo_email?(demo_email)
    demo_email.match("demo(.*?)@zeitkit\\.com")
  end

  def email_title
    if demo?
      "Demo user"
    else
      email
    end
  end

  # Returns a hash with hour, minute, s when the account will selfdestruct.
  def self_destruct_in
    return if !demo?
    t = (created_at + 48.hours - Time.zone.now).to_i
    mm, ss = t.divmod(60)
    hh, mm = mm.divmod(60)
    {
      hours: hh,
      minutes: mm,
      seconds: ss
    }
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

  def show_tutorial?
    show_tutorial
  end

  def self.email_new_users
    self.no_signup_email_sent.older_than_30_minutes.no_demo_user.each do |user|
      begin
        UserMailer.signup_email(user).deliver
      rescue
        nil
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
    if Rails.env.test? || Rails.env.development? || demo?
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

  def converted_from_demo?
    return false if new_record?
    return false unless email_changed?
    demo_email?(email_was)
  end

  def update_after_demo_conversion
    if converted_from_demo? && !demo?
      self.created_at = Time.zone.now
      get_name_from_api
    end
    true
  end

  def time_zone=(new_time_zone)
    timezones = ActiveSupport::TimeZone.all.map(&:name)

    if new_time_zone.blank?
      new_time_zone = "Europe/London"
    end

    if timezones.include?(new_time_zone.try(:split, "/").try(:last))
      result = new_time_zone.split("/").last
    else
      result = "London"
    end

    write_attribute(:time_zone, result)
  end

  def github_client
    @github_client ||= Github.new(self) if github_token
  end

  def set_temp_username
    if username.blank?
      self.username = self.class.unused_random_username
    end
    true
  end

end
