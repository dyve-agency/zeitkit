class CreateUserTeams < ActiveRecord::Migration
  def change
    create_table :teams_users, id: false do |t|
      t.belongs_to :user, index: true
      t.belongs_to :team, index: true

      t.timestamps
    end
  end
end
