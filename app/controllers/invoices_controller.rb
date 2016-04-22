class InvoicesController < ApplicationController

  load_and_authorize_resource

  respond_to :html, :json

  def index
    @invoices = @invoices.order("invoice_date DESC")
    @chart_data = current_user.invoices.where("invoice_date >= ?", 1.year.ago).group_by_month(:invoice_date).sum("total_cents / 100")
    respond_with @invoices
  end

  def pdf_export
    @invoice = @invoice.decorate
    @client = @invoice.client
    @worklogs = @invoice.worklogs.order("start_time DESC").includes(:user, :timeframes).decorate
    @sum = Money.new @worklogs.map(&:total).inject(:+)
    seconds = Worklog.range_duration_seconds(@worklogs)
    @hours = Worklog.hours_from_seconds seconds
    @minutes = Worklog.remaining_minutes_from_seconds seconds
    # For this to work you need to precompile your assets once.
    @invoice_pdf = PDFKit.new(render_to_string(action: "show", :layout => 'application_print'))
    @invoice_pdf.stylesheets << temp_stylesheet
    send_data(@invoice_pdf.to_pdf, filename: @invoice.pdf_export_file_name, type: 'application/pdf')
  end

  def worklogs_export
    @invoice = @invoice.decorate
    @client = @invoice.client
    @worklogs = @invoice.worklogs.order("start_time DESC").includes(:user, :timeframes).decorate
    @sum = @worklogs.map(&:total).inject(:+)
    seconds = @worklogs.map(&:duration).inject(:+) || 0
    @hours = Worklog.hours_from_seconds seconds
    @minutes = Worklog.remaining_minutes_from_seconds seconds

    @worklogs_pdf = PDFKit.new(render_to_string(action: "../worklogs/detailed_index", layout: 'application_print'))
    @worklogs_pdf.stylesheets << temp_stylesheet
    send_data(@worklogs_pdf.to_pdf, filename: @invoice.worklogs_export_file_name, type: 'application/pdf')
  end

  def show
    @invoice = @invoice.decorate
    @client = @invoice.client
    render :show, layout: "application_print"
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
    @worklogs = @client.worklogs.unpaid.no_invoice.includes(:timeframes).sort_by(&:start_time)
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

  def reset_date
    @invoice.update_column :created_at, DateTime.now
    @invoice.update_column :invoice_date, Date.today
    redirect_to invoices_path, notice: "Invoice date was updated"
  end

  def set_invoice_worklogs
    @client ? @client.worklogs.unpaid.no_invoice.includes(:timeframes).sort_by(&:start_time) : nil
  end

  def set_invoice_expenses
    @client ? @client.expenses.unpaid.no_invoice.oldest_first : nil
  end

  def temp_stylesheet
    manifest      = Rails.application.assets_manifest
    path          = File.join(manifest.dir, manifest.assets['application_print.css'])
    css           = File.read(path)
    temp_css_file = "#{Rails.root}/tmp/tmp-#{Time.now.to_i}.css"
    File.open(temp_css_file, 'w') { |file| file.write(css) }
    temp_css_file
  end

end
