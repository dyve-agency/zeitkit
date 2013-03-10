class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.integer :user_id
      t.integer :client_id
      t.integer :total_cents
      t.text :reason
      t.boolean :paid

      t.timestamps
    end
  end
end
