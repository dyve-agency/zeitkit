class StartTimeSavesController < ApplicationController
  respond_to :json

  def destroy
    @start_time_save = current_user.start_time_save
    @start_time_save.destroy
    respond_with(@start_time_save)
  end

end
