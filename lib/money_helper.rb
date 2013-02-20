module CurrencyHelper
  def self.included(base)
    base.validates :currency, presence: true
  end

  # For now every currency defaults to Euro
  def currency
    read_attribute(:currency) ? Money::Currency.new(read_attribute(:currency)) : nil
  end

  # For now every currency defaults to Euro
  def currency=(new_currency)
    write_attribute(:currency, Money.default_currency.iso_code.to_s)
  end

end
