class RemoveClientIdFromProducts < ActiveRecord::Migration
  def up
    remove_column :products, :client_id
  end

  def down
    add_column :products, :client_id, :integer
  end
end
