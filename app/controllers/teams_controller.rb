class TeamsController < ApplicationController
  def show
    @team = current_user.teams.find(params[:id])
    @form = TeamAggregator.new(params[:team_aggregrator])
    @form.team = @team
  end
end
