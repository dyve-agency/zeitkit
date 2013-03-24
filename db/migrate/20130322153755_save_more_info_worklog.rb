class SaveMoreInfoWorklog < ActiveRecord::Migration
  def change
    rename_table :start_time_saves, :temp_worklog_saves
    remove_column :temp_worklog_saves, :start_time
    add_column :temp_worklog_saves, :summary, :text
    add_column :temp_worklog_saves, :from_date, :string
    add_column :temp_worklog_saves, :from_time, :string
    add_column :temp_worklog_saves, :to_date, :string
    add_column :temp_worklog_saves, :to_time, :string
    add_column :temp_worklog_saves, :client_id, :integer
    add_column :temp_worklog_saves, :show_user, :boolean
  end
end
