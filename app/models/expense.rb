class Expense < ActiveRecord::Base
  include TotalHelper
  total_and_currency_for attribute_name: :total, cents_attribute: :total_cents

  include NilStrings

  attr_accessible :client_id, :total, :user_id, :reason

  belongs_to :user
  belongs_to :client
  belongs_to :invoice

  validates :user_id, :client_id, :total, :reason, presence: true

  scope :paid, -> { where(invoice_id: !nil) }
  scope :unpaid, -> { where(invoice_id: nil) }
  scope :no_invoice, -> { where(invoice_id: nil) }
  scope :oldest_first, -> { order("created_at ASC") }

  def string_fields_to_nil
    [:reason]
  end

  def short_reason
    cut_off = 40
    return reason if reason.length < cut_off
    "#{reason[0..(cut_off - 1)]}..."
  end

  def title
    "#{short_reason} - #{total.to_s}#{total.currency.symbol}"
  end

  def invoice_title(invoice)
    markdown(reason)
  end

  def invoiced?
    invoice_id
  end

  private

  def markdown(content)
    Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(content).html_safe
  end

end
