class UsersController < ApplicationController
  respond_to :html

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      user = login(params[:user][:email], params[:user][:password], true)
      redirect_to root_path, :notice => "Successfully signed up. Thanks."
    else
      render :new
    end
  end

  def show
  end


end
