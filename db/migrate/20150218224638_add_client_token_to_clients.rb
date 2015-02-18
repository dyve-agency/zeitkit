class AddClientTokenToClients < ActiveRecord::Migration
  def change
    add_column :clients, :client_token, :string
  end
end
