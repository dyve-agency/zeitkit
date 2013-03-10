class NotesController < ApplicationController
  load_and_authorize_resource except: :public

  def index
    @notes = current_user.notes
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @notes }
    end
  end

  def public
    @note = Note.find(params[:id])
    @content = @note.markdown_converted_content
    if @note.share_token && params[:t] == @note.share_token
      respond_to do |format|
        format.html {}
        format.json { render json: @note }
      end
    else
      respond_to do |format|
        format.html {
          flash[:error] = "Sorry, your share link is invalid."
          redirect_to root_url
        }
        format.json { render json: @note }
      end
    end
  end

  def show
    @content = @note.markdown_converted_content
    respond_to do |format|
      format.html {}
      format.json { render json: @note }
    end
  end

  def new
    @note = Note.new
    @note.user = current_user
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @note }
    end
  end

  def edit
  end

  def dynamic_create_path
  end

  def create
    @note = Note.new(params[:note])
    @note.user = current_user

    respond_to do |format|
      if @note.save
        if params[:client_show]
          format.html { redirect_to client_path(params[:client_show]), notice: 'Note was successfully created.' }
          format.json { render json: @note, status: :created, location: @note }
        else
          format.html { redirect_to @note, notice: 'Note was successfully created.' }
          format.json { render json: @note, status: :created, location: @note }
        end
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
      format.html { redirect_to user_notes_path(current_user) }
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
