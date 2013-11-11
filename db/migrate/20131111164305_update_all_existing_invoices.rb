class UpdateAllExistingInvoices < ActiveRecord::Migration

  def change
    Invoice.all.each do |invoice|
      invoice.set_subtotal!
      invoice.set_total!
      invoice.save
    end


  end

end
