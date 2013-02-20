class InvoiceDefaultController < ApplicationController
  load_and_authorize_resource

  def edit
  end

  def update
    if @invoice_default.update_attributes(params[:invoice_default])
      redirect_to user_invoices_path(current_user), notice: 'Successfully updated your invoice template.'
    else
      render action: "edit"
    end
  end

end
