class Client < ActiveRecord::Base
  include HourlyRateHelper

  include NilStrings

  attr_accessible :name,
    :company_name,
    :zip,
    :street,
    :city,
    :hourly_rate,
    :client_shares_attributes

  belongs_to :user
  has_many :worklogs, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :expenses, dependent: :destroy
  has_many :client_shares, dependent: :destroy

  accepts_nested_attributes_for :client_shares, allow_destroy: true

  validates :user, :name, presence: true
  validates :name, uniqueness: {scope: :user_id, message: "You can only have the client once."}
  validates_numericality_of :hourly_rate, :greater_than => 0, :allow_blank => false

  validate :only_one_client_share_per_user

  def string_fields_to_nil
    [:company_name, :zip, :street, :city]
  end

  def contact_info_entered?
    name && city && street && zip
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
end
