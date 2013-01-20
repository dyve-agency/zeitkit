class WorklogsController < ApplicationController
  # GET /worklogs
  # GET /worklogs.json
  def index
    @user = User.find(params[:user_id])
    @worklogs = @user.worklogs.order("created_at DESC")
    params[:client] ? @worklogs = Client.find(params[:client]).worklogs.order("created_at DESC") : nil

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @worklogs }
    end
  end

  # GET /worklogs/1
  # GET /worklogs/1.json
  def show
    @worklog = Worklog.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @worklog }
    end
  end

  # GET /worklogs/new
  # GET /worklogs/new.json
  def new
    @worklog = Worklog.new
    @worklog.user = current_user
    @worklog.client = current_user.clients ? current_user.clients.first : nil
    params[:client] ? @worklog.client = current_user.clients.find(params[:client]) : nil

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @worklog }
    end
  end

  # GET /worklogs/1/edit
  def edit
    @worklog = Worklog.find(params[:id])
  end

  # POST /worklogs
  # POST /worklogs.json
  def create
    @worklog = Worklog.new(params[:worklog])
    @worklog.user = current_user

    respond_to do |format|
      if @worklog.save
        format.html { redirect_to @worklog, notice: 'Worklog was successfully created.' }
        format.json { render json: @worklog, status: :created, location: @worklog }
      else
        format.html { render action: "new" }
        format.json { render json: @worklog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /worklogs/1
  # PUT /worklogs/1.json
  def update
    @worklog = Worklog.find(params[:id])

    respond_to do |format|
      if @worklog.update_attributes(params[:worklog])
        format.html { redirect_to @worklog, notice: 'Worklog was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @worklog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /worklogs/1
  # DELETE /worklogs/1.json
  def destroy
    @worklog = Worklog.find(params[:id])
    @worklog.destroy

    respond_to do |format|
      format.html { redirect_to worklogs_url }
      format.json { head :no_content }
    end
  end
end
