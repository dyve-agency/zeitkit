module TotalHelper
  extend ActiveSupport::Concern
  include CurrencyHelper

  def total
    Money.new total_cents, currency || Money.default_currency
  end

  def total_with_currency
    "#{total.to_s}#{total_rate.currency.symbol}"
  end

  def total=(new_amount)

    return unless new_amount

    if new_amount.is_a?(Money)
      write_attribute(:total_cents, new_amount.cents)
      self.currency = new_amount.currency
      result = new_amount
    elsif new_amount.is_a?(Integer)
      write_attribute(:total_cents, new_amount)
      result = Money.new(new_amount, currency)
    elsif new_amount.is_a?(String) && new_amount.to_i
      amount_from_string = (new_amount.to_f * 100).to_i
      write_attribute(:total_cents, amount_from_string)
      result = Money.new(amount_from_string, currency)
    end
    result
  end
end

