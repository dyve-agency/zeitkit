module HourlyRateHelper
  extend ActiveSupport::Concern
  include CurrencyHelper

  def hourly_rate
    Money.new hourly_rate_cents, currency
  end

  def hourly_rate_with_currency
    "#{hourly_rate.to_s}#{hourly_rate.currency.symbol}"
  end

  def hourly_rate=(new_amount)
    return unless new_amount

    if new_amount.is_a?(Money)
      write_attribute(:hourly_rate_cents, new_amount.cents)
      self.currency = new_amount.currency
      result = new_amount
    elsif new_amount.is_a?(Integer)
      write_attribute(:hourly_rate_cents, new_amount)
      result = Money.new(new_amount, currency)
    elsif new_amount.is_a?(String) && new_amount.to_i
      amount_from_string = (new_amount.to_f * 100).to_i
      write_attribute(:hourly_rate_cents, amount_from_string)
      result = Money.new(amount_from_string, currency)
    end
    result
  end

end
