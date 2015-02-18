class UpdateAllClientsWithToken < ActiveRecord::Migration
  def up
    Client.find_each do |client|
      client.generate_access_token
      client.save!
    end
  end

  def down
    Client.update_all client_token: nil
  end
end
