class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.text :content
      t.integer :user_id
      t.integer :client_id

      t.timestamps
    end
  end
end
