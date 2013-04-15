class AddHourlyRateToSave < ActiveRecord::Migration
  def change
    add_column :temp_worklog_saves, :hourly_rate_cents, :integer
  end
end
