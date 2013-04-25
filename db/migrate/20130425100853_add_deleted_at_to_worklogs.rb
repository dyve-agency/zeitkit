class AddDeletedAtToWorklogs < ActiveRecord::Migration
  def change
    add_column :worklogs, :deleted_at, :datetime
  end
end
