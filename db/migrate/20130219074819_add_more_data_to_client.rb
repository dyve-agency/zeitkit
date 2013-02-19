class AddMoreDataToClient < ActiveRecord::Migration
  def change
    add_column :clients, :city, :string
    add_column :clients, :street, :string
    add_column :clients, :zip, :string
    add_column :clients, :company_name, :string
  end
end
