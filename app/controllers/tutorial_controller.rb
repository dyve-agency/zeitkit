class TutorialController < ApplicationController

  respond_to :json, :html

  def hide
    session[:hide_tutorial] = true
    respond_with [], status: 204, location: "hide_tutorial"
  end

  def show
    session[:hide_tutorial] = false
    render partial: "layouts/tutorial", layout: false
  end

end
