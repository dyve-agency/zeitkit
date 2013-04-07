class RemoveDatesFromInvoicesProducts < ActiveRecord::Migration
  def up
    remove_column :invoices_products, :created_at
    remove_column :invoices_products, :updated_at
  end

  def down
    add_column :invoices_products, :updated_at, :timestamp
    add_column :invoices_products, :created_at, :timestamp
  end
end
