class InvoicesController < ApplicationController
  load_and_authorize_resource

  def index
    @invoices = current_user.invoices.order("created_at DESC")
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @invoices }
    end
  end

  def pdf_export
    @client = @invoice.client
    headers["Content-Disposition"] = "attachment; filename=\"#{@invoice.filename}\""
    render "show"
  end

  def show
    @client = @invoice.client
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @invoice }
    end
  end

  # GET /invoices/new
  # GET /invoices/new.json
  def new
    @invoice.set_initial_values!
    @unpaid_worklogs = current_user.unpaid_worklogs_by_client
    @unpaid_expenses = current_user.expenses.unpaid
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @invoice }
    end
  end

  def edit
    @unpaid_worklogs = current_user.unpaid_worklogs_by_client
    @unpaid_expenses = current_user.expenses.unpaid
  end

  def create
    @invoice = Invoice.new(params[:invoice])
    @invoice.user = current_user
    @invoice.client = current_user.clients.find(@invoice.client.id)

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to @invoice, notice: 'Invoice was successfully created.' }
        format.json { render json: @invoice, status: :created, location: @invoice }
      else
        format.html { render action: "new" }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @invoice.update_attributes(params[:invoice])
        format.html { redirect_to @invoice, notice: 'Invoice was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @invoice.destroy
    respond_to do |format|
      format.html { redirect_to user_invoices_path(current_user) }
      format.json { head :no_content }
    end
  end

  def toggle_paid
    @invoice.toggle_paid
    if @invoice.save
      redirect_to user_invoices_path(current_user, params[:old_params]), notice: 'Invoice was successfully updated.'
    else
      render action: "edit"
    end
  end
end
