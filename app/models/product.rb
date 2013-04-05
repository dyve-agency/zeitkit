class Product < ActiveRecord::Base
  include TotalHelper
  include NilStrings

  attr_accessible :client_id, :total, :user_id, :title, :charge

  belongs_to :user
  belongs_to :client
  has_and_belongs_to_many :invoices

  validates :user_id, :client_id, :total, :title, :charge, presence: true

  scope :paid, joins('LEFT OUTER JOIN invoices_products ON products.id=invoices_products.product_id').where('invoices_products.invoice_id IS NOT NULL')
  scope :unpaid, joins('LEFT OUTER JOIN invoices_products ON products.id=invoices_products.product_id').where('invoices_products.invoice_id IS NULL')
  scope :no_invoice, joins('LEFT OUTER JOIN invoices_products ON products.id=invoices_products.product_id').where('invoices_products.invoice_id IS NULL')

  scope :oldest_first, order("created_at ASC")

  before_validation :check_if_charge_missing, :only => [:charge]

  def string_fields_to_nil
    [:title]
  end

  def invoice_qty(invoice)
    invoice.product_ids.count(self.id)
  end

  def short_title
    cut_off = 40
    return title if title.length < cut_off
    "#{title[0..(cut_off - 1)]}..."
  end

  def display_title
    "#{short_title} - #{(charged_total / 100).to_s}#{total.currency.symbol}"
  end

  def invoice_title(invoice)
    str = "Product: #{title} - #{(charged_total / 100).to_s}#{total.currency.symbol}" 
    count = invoice_qty(invoice)
    if (count > 1)
      str += " (" + count.to_s + ")"
    end
    str
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
