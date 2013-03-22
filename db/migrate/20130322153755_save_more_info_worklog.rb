class SaveMoreInfoWorklog < ActiveRecord::Migration
  def change
    rename_table :start_time_saves, :temp_worklog_saves
    add_column :temp_worklog_saves, :summary, :text
    add_column :temp_worklog_saves, :end_time, :date_time
    add_column :temp_worklog_saves, :client_id, :integer
    add_column :temp_worklog_saves, :show_user, :boolean
  end
end
