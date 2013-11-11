class AddDiscountToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :discount_cents, :integer
  end
end
