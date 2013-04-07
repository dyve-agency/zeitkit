class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :user_id
      t.integer :client_id
      t.integer :total_cents
      t.float :charge
      t.text :title
      t.integer :invoice_id

      t.timestamps
    end
  end
end
