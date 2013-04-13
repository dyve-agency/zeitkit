class RemoveCustomRate < ActiveRecord::Migration
  def change
    remove_column :worklogs, :custom_rate_cents
  end
end
