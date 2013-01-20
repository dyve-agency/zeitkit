class CreateWorklogs < ActiveRecord::Migration
  def change
    create_table :worklogs do |t|
      t.datetime :start
      t.datetime :end
      t.integer :user_id
      t.integer :client_id

      t.timestamps
    end
  end
end
