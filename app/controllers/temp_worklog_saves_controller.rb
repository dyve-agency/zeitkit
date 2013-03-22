class TempWorklogSavesController < ApplicationController
  respond_to :json

  def update
    @temp = current_user.temp_worklog_save
    params[:worklog].delete("paid")
    params[:worklog].delete("id")
    @temp.update_attributes params[:worklog]
    respond_with @temp
  end


end
