class AddClientShareIdToWorklogs < ActiveRecord::Migration
  def change
    add_column :worklogs, :client_share_id, :integer
  end
end
