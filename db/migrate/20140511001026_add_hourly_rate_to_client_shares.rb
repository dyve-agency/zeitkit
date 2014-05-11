class AddHourlyRateToClientShares < ActiveRecord::Migration
  def change
    add_column :client_shares, :hourly_rate_cents, :integer
  end
end
