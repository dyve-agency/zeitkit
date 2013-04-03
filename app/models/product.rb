class Product < ActiveRecord::Base
  include TotalHelper
  include NilStrings

  attr_accessible :client_id, :total, :user_id, :title, :charge

  belongs_to :user
  belongs_to :client
  has_and_belongs_to_many :invoices

  validates :user_id, :client_id, :total, :title, :charge, presence: true

  scope :paid, where(invoice_ids: !nil)
  scope :unpaid, where(invoice_ids: nil)
  scope :no_invoice, where(invoice_ids: nil)

  scope :oldest_first, order("created_at ASC")

  before_validation :check_if_charge_missing, :only => [:charge]

  def string_fields_to_nil
    [:title]
  end

  def short_title
    cut_off = 40
    return title if title.length < cut_off
    "#{title[0..(cut_off - 1)]}..."
  end

  def display_title
    "#{short_title} - #{total.to_s}#{total.currency.symbol}"
  end

  def invoice_title
    "Product: #{title} - #{total.to_s}#{total.currency.symbol}"
  end

  def invoiced?
    !invoices.empty?
  end

  def charged_total
    ((charge / 100) * total_cents) + total_cents
  end

  def check_if_charge_missing
    self.charge = self.charge == nil || self.charge < 0 ? 0.0 : self.charge
  end
end
