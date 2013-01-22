class UsersController < ApplicationController
  respond_to :html

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      user = login(params[:user][:email], params[:user][:password], true)
      redirect_to new_user_client_path(@user), :notice => "Get started by creating your first client."
    else
      render :new
    end
  end

  def show
  end

  def signup_email
    @user = User.new
    @user.email = params[:signup_email]
    temp_pw = SecureRandom.base64(10).split("=").first
    @user.set_temp_password temp_pw
    if @user.save
      user = login(@user.email, temp_pw, true)
      redirect_to new_user_client_path(@user), :notice => "Get started by creating your first client."
    else
      flash[:alert] = "Sorry, that email has already been taken/is invalid. Please try again."
      redirect_to root_path
    end
  end

end
