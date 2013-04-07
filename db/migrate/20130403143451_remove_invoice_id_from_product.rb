class RemoveInvoiceIdFromProduct < ActiveRecord::Migration
  def up
    remove_column :products, :invoice_id
  end

  def down
    add_column :products, :invoice_id, :integer
  end
end
