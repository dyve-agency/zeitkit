class AddCustomCssToInvoiceDefaults < ActiveRecord::Migration
  def change
    add_column :invoice_defaults, :custom_css, :text, default: ""
  end
end
