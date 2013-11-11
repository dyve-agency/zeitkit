class AddSubTotalToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :subtotal_cents, :integer
  end
end
