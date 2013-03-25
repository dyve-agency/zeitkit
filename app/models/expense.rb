class Expense < ActiveRecord::Base
  include TotalHelper
  include NilStrings

  attr_accessible :client_id, :paid, :total, :user_id, :reason

  belongs_to :user
  belongs_to :client
  belongs_to :invoice

  before_validation :ensure_paid_not_nil
  validates :user_id, :client_id, :total, :reason, presence: true

  scope :paid, where(paid: true)
  scope :unpaid, where(paid: false)
  scope :no_invoice, where(invoice_id: nil)

  def string_fields_to_nil
    [:reason]
  end

  def toggle_paid
    self.paid ? self.paid = false : self.paid = true
  end

  def ensure_paid_not_nil
    self.paid = false if paid.nil?
    # return true to avoid rollback error
    true
  end

  def short_reason
    cut_off = 40
    return reason if reason.length < cut_off
    "#{reason[0..(cut_off - 1)]}..."
  end

  def title
    "#{short_reason} - #{total.to_s}#{total.currency.symbol}"
  end

end
