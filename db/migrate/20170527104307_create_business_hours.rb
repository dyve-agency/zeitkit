class CreateBusinessHours < ActiveRecord::Migration
  def change
    create_table :business_hours do |t|
      t.references :user, index: true
      t.string :workday
      t.time :start_time
      t.time :end_time

      t.timestamps null: false
    end
    add_foreign_key :business_hours, :users
  end
end
