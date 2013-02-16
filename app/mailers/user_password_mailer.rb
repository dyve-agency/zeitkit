class UserPasswordMailer < ActionMailer::Base
  default from: "info@zeitkit.com"

  def temp_password_mail(temppw, user)
    @user = user
    @temppw = temppw 
    mail(:to => user.email, :subject => "Your temporary Zeitkit password.")
  end
end
