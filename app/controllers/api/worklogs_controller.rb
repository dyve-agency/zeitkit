module Api
  class WorklogsController < BaseController

    def create
      timeframes = params[:worklogs].map do |timeframe|
        Timeframe.create(started: timeframe[0], ended: timeframe[1]).id
      end

      # WARNING: Can't mass-assign protected attributes for Worklog: client, team, timeframes
      worklog = Worklog.new(client: params[:client_id], team: params[:team_id], timeframes: timeframes)

      render json: { success: worklog.save! }
    end
  end
end
