class NotesController < ApplicationController
  load_and_authorize_resource except: :public
  skip_before_filter :require_login, only: [:public]

  respond_to :html, :json

  def index
    respond_with current_user.notes.order("created_at DESC")
  end

  def public
    @note = Note.find(params[:id])
    if @note.share_token && params[:t] == @note.share_token
      respond_with @note
    else
      @note = Note.new
      respond_with [], status: 401
    end
  end

  def show
    respond_with @note
  end

  def new
  end

  def edit
  end

  def dynamic_create_path
  end

  def create
    @note = Note.new(params[:note])
    @note.user = current_user
    path = params[:client_show] ? client_path : @note
    respond_to do |format|
      if @note.save
        format.html { redirect_to path, notice: 'Note was successfully created.' }
        format.json { render json: @note, status: :created, location: @note }
      else
        format.html { render action: "new" }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @note.update_attributes(params[:note])
        format.html { redirect_to @note, notice: 'Note was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @note.destroy
    respond_to do |format|
      format.html { redirect_to notes_path }
      format.json { head :no_content }
    end
  end

  def share
    if !@note.is_shared?
      @note.set_share_token
    end
    respond_to do |format|
      format.html { redirect_to note_path(@note), notice: "Note shared. Your share link: <a href='#{@note.share_link}'>#{@note.share_link}</a>".html_safe}
      format.json { render json: @note }
    end
  end

  def new_share_link
    @note.set_share_token
    respond_to do |format|
      format.html { redirect_to note_path(@note), notice: "Regenerated share link: <a href='#{@note.share_link}'>#{@note.share_link}</a>".html_safe}
      format.json { render json: @note }
    end
  end

  def unshare
    @note.unshare!
    respond_to do |format|
      format.html { redirect_to note_path(@note), notice: "Note successfully unshared"}
      format.json { render json: @note }
    end
  end
end
