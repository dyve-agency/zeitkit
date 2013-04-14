class ClientsController < ApplicationController
  load_and_authorize_resource

  respond_to :html, :json

  def index
    respond_with @clients.order("created_at DESC")
  end

  def new
    @client = Client.new
    set_current_user @client
    @client.hourly_rate = "0"
    @client.currency
  end

  def edit
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
      render action: "new"
    end
  end

  def update
    @client = current_user.clients.find(params[:id])
    if @client.update_attributes(params[:client])
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
end
