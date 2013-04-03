class CreateInvoiceProducts < ActiveRecord::Migration
  def change
    create_table :invoices_products do |t|
      t.integer :product_id
      t.integer :invoice_id

      t.timestamps
    end
  end
end
