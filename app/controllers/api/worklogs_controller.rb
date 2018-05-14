module Api
  class WorklogsController < BaseController

    def create
      timeframes = params[:worklogs].map do |timeframe|
        Timeframe.create(started: timeframe[0], ended: timeframe[1]).id
      end

      worklog = Worklog.new(client_id: params[:client_id], team_id: params[:team_id], timeframes: timeframes)

      render json: { success: worklog.save! }
    end
  end
end
