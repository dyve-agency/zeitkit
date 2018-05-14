module Api
  class WorklogsController < BaseController

    def create
      render json: {success: true}
    end

  end
end