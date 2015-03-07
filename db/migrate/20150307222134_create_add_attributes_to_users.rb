class CreateAddAttributesToUsers < ActiveRecord::Migration
  def change
    create_table :add_attributes_to_users do |t|
      t.string :first_name
      t.string :last_name

      t.timestamps
    end
  end
end
