class Expense < ActiveRecord::Base
  include TotalHelper
  include NilStrings

  attr_accessible :client_id, :paid, :total, :user_id, :reason

  belongs_to :user
  belongs_to :client

  validates :user_id, :client_id, :total, :reason, presence: true

  def string_fields_to_nil
    [:reason]
  end

  def toggle_paid
    self.paid ? self.paid = false : self.paid = true
  end

end
