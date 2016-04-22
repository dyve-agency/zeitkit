module MoneyHelper
  def with_currency(money)
    if money
      money.to_s + money.currency.symbol
    else
      return
    end
  end
end
