class CreateInvoiceDefaults < ActiveRecord::Migration
  def change
    create_table :invoice_defaults do |t|
      t.float :vat
      t.boolean :includes_vat
      t.text :payment_terms
      t.text :payment_info
      t.text :note
      t.integer :user_id
      t.timestamps
    end
  end
end
