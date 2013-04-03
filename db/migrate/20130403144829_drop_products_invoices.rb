class DropProductsInvoices < ActiveRecord::Migration
  def up
    drop_table :product_invoices
  end

  def down
  end
end
