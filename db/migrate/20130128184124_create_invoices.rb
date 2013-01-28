class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :user_id
      t.integer :client_id
      t.boolean :includes_vat
      t.float :vat

      t.timestamps
    end
  end
end
