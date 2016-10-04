class WorklogsController < ApplicationController

  def index
    @user = current_user
    @clients = @user.clients_and_shared_clients.order("name ASC")
    if params[:updated_since]
      @worklogs = Worklog.updated_since(params[:updated_since]).where(user_id: current_user.id).includes({client: :user}, :timeframes).joins(:timeframes).order("timeframes.started DESC")
    else
      @worklogs = current_user.worklogs.includes({client: :user}, :timeframes).joins(:timeframes).order("timeframes.started DESC")
      scope_for_subquery = current_user.worklogs.reorder('')
      params[:client] ? @worklogs = @worklogs.where(client_id: params[:client]) : @worklogs
      params[:paid] == "true" ? @worklogs = @worklogs.paid : @worklogs
      params[:paid] == "false" ? @worklogs = @worklogs.unpaid : @worklogs
      params[:time] == "today" ? @worklogs = @worklogs.today(scope_for_subquery) : @worklogs
      params[:time] == "this_week" ? @worklogs = @worklogs.this_week(scope_for_subquery) : @worklogs
      params[:time] == "this_month" ? @worklogs = @worklogs.this_month(scope_for_subquery) : @worklogs
      params[:time] == "older_than_this_month" ? @worklogs = @worklogs.older_than_this_month(scope_for_subquery) : @worklogs
      params[:time] == "last_month" ? @worklogs = @worklogs.last_month(scope_for_subquery) : @worklogs
    end
    @worklogs = @worklogs.paginate(:page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json
      format.csv { render text: @worklogs.to_csv(@worklogs) }
    end
  end

  def new
    if params[:client]
      gon.client_id = params[:client].to_i
    end
  end

  def edit
    @worklog = current_user.worklogs.find(params[:id])
    gon.worklog_id = @worklog.id
  end

  def show
    @worklog = current_user.worklogs.find(params[:id])
    render json: @worklog, status: 200
  end

  def create
    if (params[:worklog] && params[:worklog][:team_id].present?)
      @team = Team.find(params[:worklog][:team_id])
    end
    form = WorklogForm.new_from_params(params[:worklog], user: current_user, team: @team)
    if form.save
      render json: form.worklog, status: 200, root: "worklog"
    else
      render json: form.errors.full_messages.to_json, status: 422
    end
  end

  def update
    @worklog = current_user.worklogs.find(params[:id])
    if (params[:worklog] && params[:worklog][:team_id].present?)
      @team = Team.find(params[:worklog][:team_id])
    end
    form = WorklogForm.new_from_params(params[:worklog], user: current_user, worklog: @worklog, team: @team)
    if form.save
      render json: form.worklog, status: 200, root: "worklog"
    else
      render json: form.errors.full_messages, status: 422
    end
  end

  def destroy
    @worklog = current_user.worklogs.find(params[:id])
    @worklog.destroy!
    redirect_to worklogs_path, notice: "Worklog successfully deleted."
  end

end
