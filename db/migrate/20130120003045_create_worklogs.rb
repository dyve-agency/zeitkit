class CreateWorklogs < ActiveRecord::Migration
  def change
    create_table :worklogs do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.integer :user_id
      t.integer :client_id

      t.timestamps
    end
  end
end
