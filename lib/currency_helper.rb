module CurrencyHelper
  extend ActiveSupport::Concern

  # Checks for the associated user for the currency
  def currency
    begin
      user.currency
    rescue
      Money.default_currency
    end
  end

end
