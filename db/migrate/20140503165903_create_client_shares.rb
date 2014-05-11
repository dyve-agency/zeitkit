class CreateClientShares < ActiveRecord::Migration
  def change
    create_table :client_shares do |t|
      t.integer :client_id
      t.integer :user_id

      t.timestamps
    end
  end
end
