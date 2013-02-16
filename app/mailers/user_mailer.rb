class UserMailer < ActionMailer::Base
  default from: "info@zeitkit.com"

  def temp_password_email(temppw, user)
    @user = user
    @temppw = temppw 
    mail(:to => user.email, :subject => "Your temporary Zeitkit password.")
  end

  def reset_password_email(user)
    @user = user
    @token = @user.reset_password_token
    mail(:to => user.email, :subject => "Your password has been reset")
  end

end
