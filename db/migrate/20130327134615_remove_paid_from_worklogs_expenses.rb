class RemovePaidFromWorklogsExpenses < ActiveRecord::Migration
  def change
    remove_column :worklogs, :paid
    remove_column :expenses, :paid
  end
end
