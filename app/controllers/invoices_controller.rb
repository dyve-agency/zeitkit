class InvoicesController < ApplicationController

  load_and_authorize_resource

  respond_to :html, :json

  def index
    @invoices = @invoices.order("created_at DESC")
    respond_with @invoices
  end

  def pdf_export
    @client = @invoice.client
    @worklogs = @invoice.worklogs.order("start_time DESC")
    @sum = Money.new @worklogs.sum(:total_cents), current_user.currency
    seconds = Worklog.range_duration_seconds(@worklogs)
    @hours = Worklog.hours_from_seconds seconds
    @minutes = Worklog.remaining_minutes_from_seconds seconds
    # For this to work you need to precompile your assets once.
    @invoice_pdf = PDFKit.new(render_to_string(action: "show", :layout => 'application_print'))
    @invoice_pdf.stylesheets << "#{Rails.root}/public/assets/application_print.css"
    if params[:export_worklogs] && @invoice.worklogs.present?
      send_file merge_pdf_files
      return
    else
      send_data(@invoice_pdf.to_pdf, :filename => @invoice.filename, :type => 'application/pdf')
    end
  end

  def merge_pdf_files
    @worklogs_pdf = PDFKit.new(render_to_string(action: "../worklogs/detailed_index", :layout => 'application_print'))
    @worklogs_pdf.stylesheets << "#{Rails.root}/public/assets/application_print.css"

    tmp_invoice_file = "#{Rails.root}/tmp/invoice-#{@invoice.id}.pdf"
    tmp_worklog_file = "#{Rails.root}/tmp/worklog-#{@invoice.id}.pdf"
    @worklogs_pdf.to_file(tmp_worklog_file)
    @invoice_pdf.to_file(tmp_invoice_file)
    pdf_merger = PdfMerger.new
    file_name = "#{Rails.root}/tmp/#{@invoice.filename}.pdf"
    pdf_merger.merge([tmp_invoice_file, tmp_worklog_file], file_name)
    file_name
  end

  def show
    @client = @invoice.client
    respond_to do |format|
      format.html
      format.json { render json: @invoice}
    end
  end

  # GET /invoices/new
  # GET /invoices/new.json
  def new
    @invoice.set_initial_values!
    @products = current_user.products.oldest_first
    @invoice.client = set_client
    if params[:client]
      @client = current_user.clients.find(params[:client])
      @invoice.client = @client
    else
      @invoice.client = set_client
    end
    @worklogs = set_invoice_worklogs
    @expenses = set_invoice_expenses
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @invoice }
    end
  end

  def edit
    @client = @invoice.client
    @worklogs = @client.worklogs.unpaid.no_invoice.oldest_first
    @expenses = @client.expenses.unpaid.no_invoice.oldest_first
    @products = current_user.products.oldest_first
  end

  def create
    @invoice = Invoice.new(params[:invoice])
    @invoice.user = current_user
    @client = current_user.clients.find(params[:invoice][:client_id])
    @invoice.client = @client

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to @invoice, notice: 'Invoice was successfully created.' }
        format.json { render json: @invoice, status: :created, location: @invoice }
      else
        wl_ids = @invoice.worklogs.map(&:id)
        ex_ids = @invoice.expenses.map(&:id)
        @worklogs = @client.worklogs.unpaid.no_invoice.reject{|wl| wl_ids.include?(wl.id)}
        @expenses = @client.expenses.unpaid.no_invoice.reject{|ex| ex_ids.include?(ex.id)}
        @products = current_user.products
        format.html { render action: "new" }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @invoice.expense_ids = []
    @invoice.worklog_ids = []
    @invoice.product_ids = []
    respond_to do |format|
      if @invoice.update_attributes(params[:invoice])
        format.html { redirect_to @invoice, notice: 'Invoice was successfully updated.' }
        format.json { head :no_content }
      else
        @client = @invoice.client
        wl_ids = @invoice.worklogs.map(&:id)
        ex_ids = @invoice.expenses.map(&:id)
        @worklogs = @client.worklogs.unpaid.no_invoice.reject{|wl| wl_ids.include?(wl.id)}
        @expenses = @client.expenses.unpaid.no_invoice.reject{|ex| ex_ids.include?(ex.id)}
        @products = current_user.products
        format.html { render action: "edit" }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @invoice.destroy
    flash[:notice] = "Invoice was successfully deleted"
    respond_with @invoice
  end

  def toggle_paid
    @invoice.toggle_paid
    if @invoice.save
      redirect_to invoices_path, notice: 'Invoice was successfully updated.'
    else
      render action: "edit"
    end
  end

  def set_client
    if current_user.invoices.any?
      @client = current_user.invoices.last.client
    elsif current_user.clients.count == 1
      @client = current_user.clients.first
    end
    @client
  end

  def set_invoice_worklogs
    @client ? @client.worklogs.unpaid.no_invoice.oldest_first : nil
  end

  def set_invoice_expenses
    @client ? @client.expenses.unpaid.no_invoice.oldest_first : nil
  end
end
