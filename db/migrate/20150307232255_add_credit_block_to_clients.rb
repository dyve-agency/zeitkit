class AddCreditBlockToClients < ActiveRecord::Migration
  def change
    add_column :clients, :credit_block_reason, :text
  end
end
