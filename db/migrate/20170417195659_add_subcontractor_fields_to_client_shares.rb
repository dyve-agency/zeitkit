class AddSubcontractorFieldsToClientShares < ActiveRecord::Migration
  def change
    add_column :client_shares, :works_as_subcontractor, :boolean, default: false
    add_column :client_shares, :subcontractor_hourly_rate_cents, :integer, default: 0
    add_column :client_shares, :subcontractor_shown_name, :string
  end
end
