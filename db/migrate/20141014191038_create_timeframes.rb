class CreateTimeframes < ActiveRecord::Migration
  def change
    create_table :timeframes do |t|
      t.datetime :started
      t.datetime :ended
      t.integer :worklog_id

      t.timestamps
    end
  end
end
