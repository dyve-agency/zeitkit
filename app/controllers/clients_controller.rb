class ClientsController < ApplicationController
  load_and_authorize_resource

  respond_to :html, :json

  def index
    respond_with @clients.order("created_at DESC")
  end

  def new
    @client = Client.new
    @client.user = current_user
    @client.hourly_rate = "0"
    @client.currency
  end

  def edit
  end

  def create
    @client.user = current_user
    if @client.save
      redirect_to user_clients_path,
        notice: "Client was successfully created. <a href='#{new_user_worklog_path(client: @client)}'>Create the first worklog for #{@client.name}.</a>".html_safe
    else
      render action: "new"
    end
  end

  def update
    if @client.update_attributes(params[:client])
      redirect_to user_clients_path(current_user), notice: 'Client was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @client.destroy
    redirect_to user_clients_path(current_user), notice: 'Client was successfully deleted.'
  end

  def show
    @notes = @client.notes.order("created_at DESC")
    @note = Note.new
    @note.client = @client
  end
end
