class SetInvoiceDateToCreatedAt < ActiveRecord::Migration
  def self.up
     Invoice.update_all("invoice_date=created_at")
   end

   def self.down
   end
end
