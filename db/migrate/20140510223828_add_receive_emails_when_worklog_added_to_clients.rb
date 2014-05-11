class AddReceiveEmailsWhenWorklogAddedToClients < ActiveRecord::Migration
  def change
    add_column :clients, :email_when_team_adds_worklog, :boolean
  end
end
