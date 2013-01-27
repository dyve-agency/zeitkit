class StartTimeSavesController < ApplicationController
  # GET /start_time_saves
  # GET /start_time_saves.json
  def index
    @start_time_saves = StartTimeSave.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @start_time_saves }
    end
  end

  # GET /start_time_saves/1
  # GET /start_time_saves/1.json
  def show
    @start_time_safe = StartTimeSave.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @start_time_safe }
    end
  end

  # GET /start_time_saves/new
  # GET /start_time_saves/new.json
  def new
    @start_time_safe = StartTimeSave.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @start_time_safe }
    end
  end

  # GET /start_time_saves/1/edit
  def edit
    @start_time_safe = StartTimeSave.find(params[:id])
  end

  # POST /start_time_saves
  # POST /start_time_saves.json
  def create
    @start_time_safe = StartTimeSave.new(params[:start_time_safe])

    respond_to do |format|
      if @start_time_safe.save
        format.html { redirect_to @start_time_safe, notice: 'Start time save was successfully created.' }
        format.json { render json: @start_time_safe, status: :created, location: @start_time_safe }
      else
        format.html { render action: "new" }
        format.json { render json: @start_time_safe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /start_time_saves/1
  # PUT /start_time_saves/1.json
  def update
    @start_time_safe = StartTimeSave.find(params[:id])

    respond_to do |format|
      if @start_time_safe.update_attributes(params[:start_time_safe])
        format.html { redirect_to @start_time_safe, notice: 'Start time save was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @start_time_safe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /start_time_saves/1
  # DELETE /start_time_saves/1.json
  def destroy
    @start_time_safe = StartTimeSave.find(params[:id])
    @start_time_safe.destroy

    respond_to do |format|
      format.html { redirect_to start_time_saves_url }
      format.json { head :no_content }
    end
  end
end
