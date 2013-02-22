module MoneyHelper
  def with_currency(money)
    money.to_s + money.currency.symbol
  end
end
