class ChangeTypeToInteger < ActiveRecord::Migration
  def change
    change_column :clients, :hourly_rate_cents, :integer
    change_column :worklogs, :hourly_rate_cents, :integer
    change_column :worklogs, :total_cents, :integer
    change_column :invoices, :total_cents, :integer
  end
end
