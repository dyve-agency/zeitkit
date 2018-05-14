class SessionsController < ApplicationController

  skip_before_filter :require_login

  def create
    user = login(
      params[:session][:username] || params[:email],
      params[:session][:password] || params[:password],
      1
    )
    respond_to do |format|
      format.html { login_user_response(user) }
      format.json { login_json_response }
    end
  end

  def destroy
    logout
    redirect_to root_url, :notice => "Logged out!"
  end

  def new
  end

  def auth_provider_callback
    auth = auth_hash
    if auth && current_user.update_attribute(:github_token, auth_hash["credentials"]["token"])
      redirect_to edit_user_path(current_user), notice: "Successfuly authed GitHub."
    else
      redirect_to edit_user_path(current_user), flash: { error: "Could not auth with GitHub." }
    end
  end

  private

  def login_user_response(user)
    if user
      redirect_back_or_to new_worklog_path, notice: "Logged in. Let's track some time."
    else
      flash.now.alert = "Email or password was invalid. <a href='#{new_password_reset_path}'>Forgot your password?</a>".html_safe
      render :new
    end
  end

  def login_json_response
    if @api_access_token
      render :json => {:access_token => @api_access_token.token }
    else
      head :unauthorized
    end
  end

  def auth_hash
    request.env['omniauth.auth']
  end

end
