class Product < ActiveRecord::Base
  include TotalHelper
  include NilStrings
  include ActionView::Helpers::NumberHelper

  attr_accessible :total, :user_id, :title, :charge

  belongs_to :user
  has_and_belongs_to_many :invoices

  validates :user_id, :total, :title, :charge, presence: true

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

  def invoice_price(invoice)
    (charged_total / 100).round(2) * invoice_qty(invoice)
  end

  def price_tag
    "#{number_with_precision((charged_total / 100).round(2), :precision => 2)}#{currency.symbol}"
  end

  def price_tag_total(invoice)
    "#{number_with_precision(invoice_price(invoice), :precision => 2)}#{currency.symbol}"
  end

  def invoice_price_title(invoice)
    "#{invoice_qty(invoice)} x #{price_tag} = #{price_tag_total(invoice)}"
  end

  def short_title
    cut_off = 40
    return title if title.length < cut_off
    "#{title[0..(cut_off - 1)]}..."
  end

  def display_title
    "#{short_title}"
  end

  def invoice_title(invoice)
    "Product: #{title} - #{invoice_price_title(invoice)}"
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
