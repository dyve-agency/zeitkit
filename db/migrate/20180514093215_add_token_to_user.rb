class AddTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :token, :string, null: true
  end
end
