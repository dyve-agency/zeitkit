class AddInvoiceToWorklog < ActiveRecord::Migration
  def change
    add_column :worklogs, :invoice_id, :integer
  end
end
