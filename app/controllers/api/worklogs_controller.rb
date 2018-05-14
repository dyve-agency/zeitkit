module Api
  class WorklogsController < BaseController

    def create
      client = Client.find(params[:client_id])
      team = Team.find(params[:team_id])

      timeframes = params[:worklogs].map do |timeframe|
        Timeframe.new(started: Time.at(timeframe[0]).to_datetime, ended: Time.at(timeframe[1]).to_datetime)
      end

      form = WorklogForm.new_from_params({}, user: @current_user, team: team)

      form.client_id = client.id
      form.timesframes = timeframes

      if form.save
        render json: {worklog: form.worklog}.to_json, status: 200
      else
        render json: {errors: form.errors.full_messages}.to_json, status: 422
      end

      # worklog = Worklog.new(
      #   user_id: @current_user.id,
      #   client_id: client.id,
      #   team_id: params[:team_id],
      #   summary: params[:description],
      #   timeframes: timeframes,
      #   hourly_rate_cents: client.hourly_rate
      # )
      #
      # render json: { success: worklog.save! }
    end
  end
end
