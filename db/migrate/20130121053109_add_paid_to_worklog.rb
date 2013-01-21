class AddPaidToWorklog < ActiveRecord::Migration
  def change
    add_column :worklogs, :paid, :boolean
  end
end
