class AddHourlyRatePriceToWorklog < ActiveRecord::Migration
  def change
    add_column :worklogs, :hourly_rate, :decimal
    add_column :worklogs, :price, :decimal
  end
end
