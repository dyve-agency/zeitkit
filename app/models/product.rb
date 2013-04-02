class Product < ActiveRecord::Base
  include TotalHelper
  include NilStrings

  attr_accessible :client_id, :total, :user_id, :title, :charge

  belongs_to :user
  belongs_to :client
  belongs_to :invoice

  validates :user_id, :client_id, :total, :title, :charge, presence: true

  scope :paid, where(invoice_id: !nil)
  scope :unpaid, where(invoice_id: nil)
  scope :no_invoice, where(invoice_id: nil)

  scope :oldest_first, order("created_at ASC")

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
    invoice_id
  end

  def charged_total
    ((charge / 100) * total_cents) + total_cents
  end
end
