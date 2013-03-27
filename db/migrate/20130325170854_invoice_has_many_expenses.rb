class InvoiceHasManyExpenses < ActiveRecord::Migration
  def up
    add_column :expenses, :invoice_id, :integer
  end
end
