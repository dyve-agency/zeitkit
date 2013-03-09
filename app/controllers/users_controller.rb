class UsersController < ApplicationController
  respond_to :html

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      user = login(params[:user][:email], params[:user][:password], true)
      redirect_to user_clients_path(@user),
        notice: welcome_message
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
      begin
        UserMailer.temp_password_email(temp_pw, @user).deliver
      ensure
        user = login(@user.email, temp_pw, true)
        redirect_to user_clients_path(@user),
          notice: welcome_message
      end
    else
      flash[:alert] = "Sorry, that email has already been taken/is invalid. Please try again."
      redirect_to root_path
    end
  end

  def dynamic_home
    flash.keep
    if current_user
      redirect_to user_clients_path(current_user)
    else
      redirect_to root_url
    end
  end

  def update_savetime
    @user = current_user
    @sts = @user.start_time_save
    @sts.start_time = params[:start_time]
    @sts.save
    respond_to do |format|
      format.json {render json: @user}
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to dynamic_home_path, notice: 'Successfuly updated details.'
    else
      render action: "edit"
    end
  end

  def welcome_message
    "Hi. Check out the header to get to know your tools <i class='icon-arrow-up'></i> <script>_gaq.push(['_trackPageview', '/register_success']);</script>".html_safe
  end

end
