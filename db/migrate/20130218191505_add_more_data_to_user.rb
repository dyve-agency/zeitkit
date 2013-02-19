class AddMoreDataToUser < ActiveRecord::Migration
  def change
    add_column :users, :city, :string
    add_column :users, :street, :string
    add_column :users, :zip, :string
    add_column :users, :company_name, :string
  end
end
