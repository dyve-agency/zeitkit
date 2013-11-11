module TotalHelper
  extend ActiveSupport::Concern
  include CurrencyHelper

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def total_and_currency_for(attribute_name: nil, cents_attribute: nil)

      return if attribute_name.blank? || cents_attribute.blank?

      # defines a dynamic getter for the currency, i.e total
      define_method "#{attribute_name}" do
        Money.new send(cents_attribute), currency || Money.default_currency
      end

      # defines a dynamic setter fot the attribute name
      define_method "#{attribute_name}=" do |new_amount|
        return if new_amount.blank?

        if new_amount.is_a?(Money)
          write_attribute(cents_attribute, new_amount.cents)
          result = new_amount
        elsif new_amount.is_a?(Integer)
          write_attribute(cents_attribute, new_amount)
          result = Money.new(new_amount, currency)
        elsif new_amount.is_a?(String) && new_amount.to_i
          amount_from_string = (new_amount.to_f * 100).to_i
          write_attribute(cents_attribute, amount_from_string)
          result = Money.new(amount_from_string, currency)
        end
        result
      end

      define_method "#{attribute_name}_with_currency" do
        "#{send(attribute_name).to_s}#{send(attribute_name).currency.symbol}"
      end

    end
  end
end
