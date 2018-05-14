module Api
  class WorklogsController < BaseController

    def create
      unless (params[:client_id].present? && params[:team_id].present? && params[:worklogs].present? && params[:description].present?)
        render status: 400
        return
      end

      client = Client.find(params[:client_id])
      team = Team.find(params[:team_id])

      timeframes = params[:worklogs].map do |timeframe|
        Timeframe.new(started: Time.at(timeframe[0]).to_datetime, ended: Time.at(timeframe[1]).to_datetime)
      end

      worklog = Worklog.new(
        user_id: @current_user.id,
        client_id: client.id,
        team_id: team.id,
      )

      form = WorklogForm.new_from_params({ client: client,
        comment: params[:description],
        hourly_rate: client.hourly_rate,
      }, user: @current_user, worklog: worklog, team: team)

      # form.client_id = client.id
      form.timeframes = timeframes

      if form.save
        render json: { worklog: form.worklog }.to_json, status: 200
      else
        render json: { errors: form.errors.full_messages }.to_json, status: 422
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
