class TeamsController < ApplicationController
  def show
    @team = current_user.teams.find(params[:id])
    @form = TeamAggregator.new(params[:team_aggregator])
    if params[:team_aggregator].blank?
      @form.specific_range = "this_month"
    end
    @form.team = @team
    @form.aggregate
  end
end
