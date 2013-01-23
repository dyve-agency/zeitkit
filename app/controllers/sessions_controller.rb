class SessionsController < ApplicationController
  respond_to :html

  def create
    user = login(params[:session][:username], params[:session][:password], 1)
    if user
      redirect_back_or_to root_url, :notice => "Logged in!"
    else
      flash.now.alert = "Email or password was invalid. <a href='#{new_password_reset_path}'>Forgot your password?</a>".html_safe
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_url, :notice => "Logged out!"
  end
end
