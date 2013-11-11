class Invoice < ActiveRecord::Base

  include NilStrings

  include TotalHelper
  total_and_currency_for attribute_name: :total, cents_attribute: :total_cents
  total_and_currency_for attribute_name: :subtotal, cents_attribute: :subtotal_cents
  total_and_currency_for attribute_name: :discount, cents_attribute: :discount_cents

  attr_accessible :client_id, :includes_vat, :user_id, :vat, :paid_on,
    :total, :note, :number, :payment_terms, :payment_info, :worklog_ids,
    :expense_ids, :product_ids, :content, :discount

  belongs_to :user
  belongs_to :client
  has_many :worklogs
  has_many :expenses
  has_and_belongs_to_many :products

  before_destroy :deassociate_worklogs
  before_destroy :deassociate_expenses
  before_destroy :deassociate_products

  before_validation :set_initial_total!, on: :create
  after_save :set_total!
  after_save :set_subtotal!

  validates :user_id, :client_id, :number, :vat, presence: true
  validates_uniqueness_of :number, scope: :user_id
  validates_numericality_of :total, :allow_blank => false

  def total_vat
    (total) * vat/100
  end

  def calc_vat_total
    if includes_vat
      total
    else
      total + total_vat
    end
  end

  def net_total
    total - discount
  end

  def string_fields_to_nil
    [:payment_terms, :payment_info, :note]
  end

  def generate_number
    return 1 if user.invoices.empty?
    # This is ok for the start.
    last = user.invoices.last.number
    if last.to_i > 0
      last.to_i + 1
    else
      last + " (Change)"
    end
  end

  def days_not_paid
    return if paid_on
    (Time.zone.now - created_at) / 1.day
  end

  # Returns a phrase including the vat.
  # Including 19.0% VAT
  # Excluding 19.0% VAT
  def including_vat_info
    phrase = includes_vat ? "Including" : "Excluding"
    "#{phrase} #{sprintf('%.2f', vat)}% VAT"
  end

  def vat_last_invoice
    return 19.0 if user.invoices.empty?
    user.invoices.last.vat
  end

  def set_initial_values!
    merge_with_invoice_defaults!
    self.vat = vat_last_invoice if !vat
    self.number = generate_number
  end

  def merge_with_invoice_defaults!
    InvoiceDefault.defaults.each do |field|
      self[field.to_s] = user.invoice_default[field.to_s]
    end
  end

  def filename
    "#{client.name.downcase.split.join("-")}-#{number}"
  end

  def toggle_paid
    paid_on ? self.paid_on = nil : self.paid_on = Time.now
  end

  def set_initial_total!
    self.total = Money.new 0, currency
  end

  def set_total!
    set_subtotal!
    cents_total = subtotal.cents - discount.cents
    new_total = Money.new cents_total, currency
    self.update_column(:total_cents, new_total.cents)
  end

  def set_subtotal!
    cents_total = worklogs.sum(:total_cents) + expenses.sum(:total_cents)
    cents_total += products.inject(0){|total, product| total + ((product.charged_total / 100).round(2) * 100)}
    new_total = Money.new cents_total, currency
    self.update_column(:subtotal_cents, new_total.cents)
  end


  def deassociate_worklogs
    Worklog.where(invoice_id: id).update_all(invoice_id: nil)
  end

  def deassociate_expenses
    Expense.where(invoice_id: id).update_all(invoice_id: nil)
  end

  def deassociate_products
    InvoicesProducts.where(invoice_id: id).destroy_all
  end

  def discount_applied?
    discount && discount.cents > 0
  end
end
