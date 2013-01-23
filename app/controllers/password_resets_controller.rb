class PasswordResetsController < ApplicationController
  # request password reset.
  # you get here when the user entered his email in the reset password form and submitted it.
  def create
    @user = User.find_by_email(params[:user][:email])
    begin
      @user.deliver_reset_password_instructions! if @user
    ensure
      redirect_to root_path, :notice => 'Instructions have been sent to your email.'
    end
  end

  # This is the reset password form.
  def edit
    @user = User.load_from_reset_password_token(params[:id])
    @token = params[:id]
    not_authenticated unless @user
  end

  # This action fires when the user has sent the reset password form.
  def update
    @token = params[:token]
    @user = User.load_from_reset_password_token(params[:token])
    not_authenticated unless @user
    # the next line makes the password confirmation validation work
    @user.password_confirmation = params[:user][:password_confirmation]
    # the next line clears the temporary token and updates the password
    if @user.change_password!(params[:user][:password])
      user = login(@user.email, params[:user][:password], 1)
      redirect_to(root_path, :notice => 'Password was successfully updated.')
    else
      flash.now[:error] = "Could not update your password"
      render :action => "edit"
    end
  end

  def new
  end

end
