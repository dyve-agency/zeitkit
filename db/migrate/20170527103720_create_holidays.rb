class CreateHolidays < ActiveRecord::Migration
  def change
    create_table :holidays do |t|
      t.references :user, index: true
      t.date :day

      t.timestamps null: false
    end
    add_foreign_key :holidays, :users
  end
end
