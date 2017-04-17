class ClientShare < ActiveRecord::Base
  include TotalHelper
  total_and_currency_for attribute_name: :hourly_rate, cents_attribute: :hourly_rate_cents
  total_and_currency_for attribute_name: :subcontractor_hourly_rate, cents_attribute: :subcontractor_hourly_rate_cents


  attr_accessible :client_id,
                  :user_id,
                  :username,
                  :hourly_rate,
                  :works_as_subcontractor,
                  :subcontractor_hourly_rate,
                  :subcontractor_shown_name
  belongs_to :client
  belongs_to :user
  has_many :worklogs

  validates :client_id, uniqueness: { scope: :user_id, message: "Can only share the client once per user." }
  validates :user_id, :client_id, presence: true
  # if the client share acts as a subcontractor, then we need other data to be
  # present such as the hourly rate for instance.
  validates :subcontractor_hourly_rate, :subcontractor_shown_name, presence: true, if: :works_as_subcontractor?

  before_validation :set_user_id_from_username

  validate :username_must_exist
  def set_username_from_userid
    return nil if user_id.blank?
    found_user = User.where(id: user_id).first
    if found_user
      self.username = found_user.username
    end
    self.username
  end

  def set_user_id_from_username
    if username.present? && user = User.where(username: username).first
      self.user_id = user.id
    end
    true
  end

  def username_must_exist
    # Only validate if user id has not been set yet.
    if username.present? && user_id.blank?
      user = User.where(username: username).first
      if user.blank?
        errors.add(:username, "Username does not exist.")
      end
    end
    true
  end
end
