class UseRubyMoney < ActiveRecord::Migration
  def change
    rename_column :clients, :hourly_rate, :hourly_rate_cents
    rename_column :worklogs, :hourly_rate, :hourly_rate_cents
    rename_column :worklogs, :price, :total_cents
    rename_column :invoices, :total, :total_cents
    add_column :users, :currency, :string
  end

end
