class UserMailer < ActionMailer::Base
  default from: "Zeitkit team <info@zeitkit.com>"

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

  def signup_email(user)
    @user = user
    @name = user.first_name
    mail(to: user.email, subject: "Checking in from Zeitkit", from: "Hendrik Kleinwaechter <hendrik@zeitkit.com>")
  end

end
