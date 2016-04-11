class ChangeInvoiceDateFromDateToDateTime < ActiveRecord::Migration
  def change
    change_column :invoices, :invoice_date, :datetime
  end
end
