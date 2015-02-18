class ClientsController < ApplicationController
  load_and_authorize_resource

  respond_to :html, :json

  def index
    respond_to do |format|
      format.html do
        @clients = current_user.clients.order("created_at DESC")
        @client_shares = current_user.client_shares.includes(client: :user)
        if params[:updated_since]
          @clients = @clients.updated_since(params[:updated_since])
        end
        render "index"
      end
      format.json {render json: current_user.clients_and_shared_clients}
    end
  end

  def new
    @client = Client.new
    set_current_user @client
    @client.hourly_rate = "1"
    @client.currency
    @client_share_base = ClientShare.new(client_id: @client.id, hourly_rate: @client.hourly_rate)
  end

  def edit
    @client = current_user.clients.find(params[:id])
    @client_share_base = ClientShare.new(client_id: @client.id, hourly_rate: @client.hourly_rate)
  end

  def create
    @client.user = current_user
    if @client.save
      redirect_to clients_path,
        notice: "Client was successfully created.
          <ul>
            <li><a href='#{new_worklog_path(client: @client)}'>Create the first worklog for #{@client.name}.</a></li>
            <li><a href='#{new_invoice_path(client: @client)}'>Or, create an invoice.</a></li>
            <li><a href='#{client_path(@client)}'>Or, take a note.</a></li>
          </ul>".html_safe
    else
      @client_share_base = ClientShare.new(client_id: @client.id, hourly_rate: @client.hourly_rate)
      render action: "new"
    end
  end

  def update
    @client = current_user.clients.find(params[:id])
    @client.assign_attributes(params[:client])
    @client.client_shares.each do |cs|
      cs.set_user_id_from_username
    end
    if @client.save
      redirect_to clients_path, notice: 'Client was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @client.destroy
    redirect_to clients_path, notice: 'Client was successfully deleted.'
  end

  def show
    @notes = @client.notes.order("created_at DESC")
    @note = Note.new
    @note.client = @client
  end

  def activity
    @total_costs = 0
    @client = Client.find(params[:id])
    @form           = ClientAggregator.new(params[:client_aggregator])
    @form.client    = @client
    @form.base_user = current_user
    if params[:client_aggregator].blank?
      @form.specific_range = "this_month"
    end
    @form.aggregate
  end
end
