class AddTeamIdToWorklogs < ActiveRecord::Migration
  def change
    add_column :worklogs, :team_id, :integer
    add_foreign_key :worklogs, :teams, column: :team_id
  end
end
