class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.decimal :hourly_rate, :precision => 8, :scale => 2
      t.integer :user_id, :null => false

      t.timestamps
    end
  end
end
