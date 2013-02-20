class InvoiceDefault < ActiveRecord::Base
  include NilStrings
  attr_accessible :includes_vat, :note, :payment_info, :payment_terms, :vat

  belongs_to :user
  validates_uniqueness_of :user_id

  def string_fields_to_nil
    [:payment_terms, :payment_info, :note]
  end

  def self.defaults
    [:payment_terms, :payment_info, :note, :vat, :includes_vat]
  end
end
