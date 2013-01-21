class AddSummaryToWorklog < ActiveRecord::Migration
  def change
    add_column :worklogs, :summary, :text
  end
end
