class AddMoreFieldsToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :content, :text
    add_column :invoices, :payment_terms, :text
    add_column :invoices, :payment_info, :text
  end
end
