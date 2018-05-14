module Api
  class WorklogsController < BaseController

    def index
      render json: { worklogs: [
        { "id" => 7635,
          "start_time" => "Sun, 13 May 2018 10 : 55 : 00 UTC + 00 : 00",
          "end_time" => "Sun, 13 May 2018 17 : 55 : 00 UTC + 00 : 00",
          "user_id" => "369",
          "client_id" => "391",
          "created_at" => "Sun, 13 May 2018 17 : 55 : 55 UTC + 00 : 00",
          "updated_at" => "Sun, 13 May 2018 17 : 55 : 55 UTC + 00 : 00",
          "hourly_rate_cents" => "6500",
          "total_cents" => "45500",
          "summary" => "Esp to es, making the world a better place\n" + "\n" + "Notifications über den Upload-Status der Produkte anzeigen",
          "invoice_id" => nil,
          "deleted_at" => nil,
          "client_share_id" => 2,
          "team_id" => "1"
        },
        {
          "id" => "7635",
          "start_time" => "Sun, 13 May 2018 10 : 55 : 00 UTC + 00 : 00",
          "end_time" => "Sun, 13 May 2018 17 : 55 : 00 UTC + 00 : 00",
          "user_id" => "369",
          "client_id" => "391",
          "created_at" => "Sun, 13 May 2018 17 : 55 : 55 UTC + 00 : 00",
          "updated_at" => "Sun, 13 May 2018 17 : 55 : 55 UTC + 00 : 00",
          "hourly_rate_cents" => "6500",
          "total_cents" => "45500",
          "summary" => "Esp to es, making the world a better place\n" + "\n" + "Notifications über den Upload-Status der Produkte anzeigen",
          "invoice_id" => nil,
          "deleted_at" => nil,
          "client_share_id" => "2",
          "team_id" => "1"
        }
      ]}.to_json
    end

    def show
      render json: {
        "id" => "7635",
        "start_time" => "Sun, 13 May 2018 10 : 55 : 00 UTC + 00 : 00",
        "end_time" => "Sun, 13 May 2018 17 : 55 : 00 UTC + 00 : 00",
        "user_id" => "369",
        "client_id" => "391",
        "created_at" => "Sun, 13 May 2018 17 : 55 : 55 UTC + 00 : 00",
        "updated_at" => "Sun, 13 May 2018 17 : 55 : 55 UTC + 00 : 00",
        "hourly_rate_cents" => "6500",
        "total_cents" => "45500",
        "summary" => "Esp to es, making the world a better place\n" + "\n" + "Notifications über den Upload-Status der Produkte anzeigen",
        "invoice_id" => nil,
        "deleted_at" => nil,
        "client_share_id" => "2",
        "team_id" => "1"
      }.to_json
    end
  end
end