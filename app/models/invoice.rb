class Invoice < ActiveRecord::Base

  include NilStrings
  include TotalHelper

  attr_accessible :client_id,
    :includes_vat,
    :user_id,
    :vat,
    :paid_on,
    :total,
    :note,
    :number,
    :content,
    :payment_terms,
    :payment_info

  belongs_to :user
  belongs_to :client
  has_many :worklogs
  has_many :expenses

  validates :user_id, :client_id, :content, :number, :total, :vat, presence: true
  validates_uniqueness_of :number, scope: :user_id

  def total_vat
    total * vat/100
  end

  def calc_vat_total
    if includes_vat
      total
    else
      total + total_vat
    end
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

end
