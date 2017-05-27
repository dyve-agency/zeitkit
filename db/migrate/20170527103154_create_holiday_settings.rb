class CreateHolidaySettings < ActiveRecord::Migration
  def change
    create_table :holiday_settings do |t|
      t.references :user, index: true
      t.boolean :use_holidays, default: false
      t.string :holiday_region

      t.timestamps null: false
    end
    add_foreign_key :holiday_settings, :users
  end
end
