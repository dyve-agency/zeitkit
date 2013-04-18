class TutorialController < ApplicationController

  respond_to :json, :html

  def hide
    session[:show_tutorial] = false
    respond_with [], status: 204, location: "hide_tutorial"
  end

  def show
    session[:show_tutorial] = true
    @tutorial = Tutorial.new current_user
    render partial: "layouts/tutorial", layout: false
  end

end
