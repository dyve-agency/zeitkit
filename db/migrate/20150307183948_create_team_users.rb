class CreateTeamUsers < ActiveRecord::Migration
  def change
    create_table :team_users do |t|
      t.belongs_to :user, index: true
      t.belongs_to :team, index: true
      t.string :state

      t.timestamps
    end
  end
end
