class Invoice < ActiveRecord::Base
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
end
