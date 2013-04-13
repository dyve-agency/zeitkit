class WorklogsController < ApplicationController
  load_and_authorize_resource

  respond_to :json, :html

  def index
    @user = current_user
    @clients = @user.clients
    @worklogs = current_user.worklogs.order("start_time DESC")
    params[:client] ? @worklogs = @worklogs.where(client_id: params[:client]) : @worklogs
    params[:paid] == "true" ? @worklogs = @worklogs.paid : @worklogs
    params[:paid] == "false" ? @worklogs = @worklogs.unpaid : @worklogs
    params[:time] == "today" ? @worklogs = @worklogs.today : @worklogs
    params[:time] == "this_week" ? @worklogs = @worklogs.this_week : @worklogs
    params[:time] == "this_month" ? @worklogs = @worklogs.this_month : @worklogs
    params[:time] == "older_than_this_month" ? @worklogs = @worklogs.older_than_this_month : @worklogs
    params[:time] == "last_month" ? @worklogs = @worklogs.last_month : @worklogs
    @sum = Money.new @worklogs.sum(:total_cents), @user.currency
    seconds = Worklog.range_duration_seconds(@worklogs)
    @hours = Worklog.hours_from_seconds seconds
    @minutes = Worklog.remaining_minutes_from_seconds seconds

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @worklogs }
      format.csv { render text: @worklogs.to_csv(@worklogs) }
    end
  end

  def new
    @worklog = Worklog.new
    @worklog.user = current_user
    @worklog.client = current_user.worklogs.any? ? current_user.worklogs.last.client : nil
    @worklog.set_time_helpers_to_now!
    params[:client] ? @worklog.client = current_user.clients.find(params[:client]) : nil
    if params[:restore]
      @worklog = @worklog.restore_based_on_saved_info
      flash.now[:notice] = "We restored the information that was unsaved."
    end
  end

  def edit
    @worklog.set_time_helpers_to_saved_times!
  end

  def create
    @worklog = Worklog.new(params[:worklog])
    @worklog.convert_time_helpers_to_date_time!
    @worklog.user = current_user
    if @worklog.save
      location = new_user_worklog_path
      flash[:notice] = "Worklog was successfully created. Create another one - or: <a href='#{user_worklogs_path}'>Go back.</a>".html_safe
    end
    respond_with @worklog, location: location
  end

  def update
    @worklog.assign_attributes(params[:worklog])
    @worklog.convert_time_helpers_to_date_time!
    @worklog.user = current_user
    if @worklog.save
      redirect_to user_worklogs_path(current_user), notice: 'Worklog was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @worklog.destroy
    redirect_to user_worklogs_path(current_user)
  end

end
