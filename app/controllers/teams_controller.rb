class TeamsController < ApplicationController
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
end