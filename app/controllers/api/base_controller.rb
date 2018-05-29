module Api
  class BaseController < ActionController::Base

    before_filter :authenticate

    private

    def authenticate
      authenticate_or_request_with_http_token do |token, options|
        @current_user = User.find_by(token: token)
      end

      unless @current_user
        return head :unauthorized
      end
    end
  end
end
