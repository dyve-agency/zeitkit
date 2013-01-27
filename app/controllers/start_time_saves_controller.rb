class StartTimeSavesController < ApplicationController
  respond_to :json

  def destroy
    @start_time_safe = StartTimeSave.find(params[:id])
    @start_time_safe.destroy
    respond_with(@start_time_save)
  end

end
