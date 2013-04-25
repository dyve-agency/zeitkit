class UsersController < ApplicationController
  respond_to :html, :json
  skip_before_filter :require_login, only: [:new, :create, :signup_email, :dynamic_home]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      user = login(params[:user][:email], params[:user][:password], true)

      respond_to do |format|
        format.html { redirect_to clients_path, notice: welcome_message }
        format.json { render status: 201 }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.json { render status: 400, json: { :errors => @user.errors.full_messages } }
      end
    end
  end

  def show
  end

  def signup_email
    @user = User.new

    # TODO: ensure uniqueness of random mail
    if params[:singup_email] == nil
      @user.email = 'demo' + SecureRandom.base64(10).split("=").first + '@zeitkit.com'
    else
      @user.email = params[:signup_email]
    end

    temp_pw = SecureRandom.base64(10).split("=").first
    @user.set_temp_password temp_pw
    if @user.save
      if @user.demo?
        user = login(@user.email, temp_pw, true)
        redirect_to clients_path, notice: welcome_message
      else
        begin
          UserMailer.temp_password_email(temp_pw, @user).deliver
        ensure
          user = login(@user.email, temp_pw, true)
          redirect_to clients_path, notice: welcome_message
        end
      end
    else
      flash[:alert] = "Sorry, that email has already been taken/is invalid. Please try again."
      redirect_to root_path
    end
  end

  def dynamic_home
    flash.keep
    if current_user
      redirect_to clients_path
    else
      redirect_to root_url
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to dynamic_home_path, notice: 'Successfuly updated user details.'
    else
      render action: "edit"
    end
  end

  def welcome_message
    "Thank you for testing Zeitkit.<script>_gaq.push(['_trackPageview', '/register_success']);</script>".html_safe
  end

end
