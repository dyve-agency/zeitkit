class Client < ActiveRecord::Base
  include HourlyRateHelper
  include NilStrings

  attr_accessible :name,
    :company_name,
    :zip,
    :street,
    :city,
    :hourly_rate,
    :client_shares_attributes,
    :email_when_team_adds_worklog

  attr_accessor :is_shared

  belongs_to :user
  has_many :worklogs, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :expenses, dependent: :destroy
  has_many :client_shares, dependent: :destroy

  accepts_nested_attributes_for :client_shares, allow_destroy: true

  before_validation :generate_access_token, on: :create

  validates :client_token, uniqueness: true, presence: true
  validates :user, :name, presence: true
  validates :name, uniqueness: {scope: :user_id, message: "You can only have the client once."}
  validates_numericality_of :hourly_rate, :greater_than => 0, :allow_blank => false

  validate :only_one_client_share_per_user

  def string_fields_to_nil
    [:company_name, :zip, :street, :city]
  end

  def currency
    if user
      user.currency
    else
      Money.default_currency
    end
  end

  def contact_info_entered?
    name && city && street && zip
  end

  def name_with_sharer
    if client_shares.any?
      "#{name} (#{user.username})"
    else
      name
    end
  end

  def self.updated_since(unixtimestamp)
    self.unscoped.where("updated_at >= ?", Time.at(unixtimestamp.to_i).to_datetime)
  end

  def only_one_client_share_per_user
    shares_to_check = client_shares.reject {|cs| cs.marked_for_destruction? }
    grouped = shares_to_check.group_by {|cs| cs.user_id}
    if grouped.select {|user_id, client_shares| client_shares.length > 1 }.present?
      errors.add(:base, "You can only share the client once per user" )
    end
    true
  end

  def generate_access_token
    begin
      self.client_token = SecureRandom.hex
    end while Client.exists?(client_token: self.client_token)
  end
end
