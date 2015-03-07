class TeamsController < ApplicationController

  before_filter :load_team, only: %i[show edit update destroy members]

  def index
    @team_users = current_user.team_users.preload(:user, team: [:users]).joins(:team).order("name ASC").where(state: "confirmed")
    @pending_invites = current_user.team_users.pending
  end

  def new
    @team = Team.new
  end

  def edit
  end

  def members
    @team_users = @team.team_users.order("state DESC, users.username ASC").
      joins(:user).preload(:user)
    @form = TeamInviteForm.new(team_id: @team.id)
  end

  def update
    if @team.update_attributes params[:team]
      redirect_to teams_path, notice: "Team successfully updated"
    else
      render "edit"
    end
  end

  def create
    @team = Team.new(params[:team])
    @team.creator = current_user
    @team.users << current_user
    tf = @team.team_users.first
    tf.state = "confirmed"
    if @team.save
      redirect_to members_team_path(@team), notice: "Team successfully created. You can now invite users."
    else
      render "new"
    end
  end

  def show
    @team           = current_user.teams.find(params[:id])
    @form           = TeamAggregator.new(params[:team_aggregator])
    @form.team      = @team
    @form.base_user = current_user
    if params[:team_aggregator].blank?
      @form.specific_range = "this_month"
    end
    @form.aggregate
  end

  def destroy
    if @team.created_by? current_user
      @team.destroy
      redirect_to teams_path, notice: "Team successfully deleted"
    else
      redirect_to teams_path, alert: "Could not delete team"
    end
  end

private
  def load_team
    @team = current_user.teams.find(params[:id])
  end
end
