class ClientsController < ApplicationController
  load_and_authorize_resource

  def index
    @user = User.find(params[:user_id])
    @clients = @clients.order("created_at DESC")
  end

  def new
    @client = Client.new
    @client.user = current_user
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
      redirect_to @client, notice: 'Client was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @client.destroy
    redirect_to clients_url
  end
end
