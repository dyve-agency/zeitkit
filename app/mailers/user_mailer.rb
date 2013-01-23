class UserMailer < ActionMailer::Base
  default from: "info@zeittracker.com"

  def temp_password_mail(temppw, user)
    @user = user
    @temppw = temppw 
    mail(:to => user.email, :subject => "Your temporary Zeittracker password.")
  end
end
