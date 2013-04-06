class CustomHourlyRate < ActiveRecord::Migration
  def change
    add_column :worklogs, :custom_rate_cents, :integer
  end
end
