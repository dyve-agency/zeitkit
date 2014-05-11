class AddUsernameToClientShares < ActiveRecord::Migration
  def change
    add_column :client_shares, :username, :string
  end
end
