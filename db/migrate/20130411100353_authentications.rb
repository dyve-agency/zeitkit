class Authentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.integer :user_id
      t.integer :uid
      t.string :provider

      t.timestamps
    end
  end
end
