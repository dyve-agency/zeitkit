class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :user_id
      t.integer :client_id
      t.string :number
      t.integer :total
      t.boolean :includes_vat
      t.datetime :paid_on
      t.float :vat
      t.text :note

      t.timestamps
    end
  end
end
