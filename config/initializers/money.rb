class Money
  self.default_currency = Currency.new(:eur)

  class Currency
    def self.pretty_currency_names
      priority_currencies = [:EUR, :USD, :GBP, :CAD, :CNY]
      priority_table = priority_currencies.map {|c| new(c) }.map {|c| [c.name, c.iso_code]}

      lower_priority_table = table.select do |k,v|
        !priority_currencies.include?(v[:iso_code].to_sym)
      end.map {|k,v| [table[k][:name], table[k][:iso_code]]}

      priority_table + lower_priority_table
    end

    def self.all
      table.keys.map do |c|
        new(c)
      end
    end
  end
end

