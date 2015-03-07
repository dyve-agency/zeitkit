class TutorialController < ApplicationController

  def hide
    current_user.show_tutorial = false
    current_user.save
    render json: {}, status: 204
  end

  def show
    current_user.show_tutorial = true
    current_user.save
    render json: {}, status: 200
  end

end
