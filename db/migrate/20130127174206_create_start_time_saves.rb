class CreateStartTimeSaves < ActiveRecord::Migration
  def change
    create_table :start_time_saves do |t|
      t.integer :user_id
      t.datetime :start_time

      t.timestamps
    end
  end
end
