module Api
  class BaseController < ActionController::Base
    # TODO: Do not parase'access_token' from get-string,
    # but rather some header field

    before_filter :check_authentication

    def check_authentication
      if params[:access_token].present?
        validate_token(params[:access_token])
        unless @current_user
          return head :unauthorized
        end
      else
        return head :unauthorized
      end
    end

    private

    def validate_token(token)
      @current_user = User.find_by_token(token)
    end
  end
end