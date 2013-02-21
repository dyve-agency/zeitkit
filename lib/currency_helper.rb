module CurrencyHelper
  extend ActiveSupport::Concern

  # Checks for the associated user for the currency
  def currency
    user.currency
  end

end
