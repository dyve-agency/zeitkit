class AddInvoiceDateToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :invoice_date, :date
  end
end
