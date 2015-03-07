class TeamMailer < ActionMailer::Base
  default from: "Zeitkit team <info@zeitkit.com>"

  def invite_user user: nil, team: nil, inviter: nil
    raise ArgumentError if [user, team, inviter].any?(&:blank?)
    @user = user
    @team = team
    @inviter = inviter
    mail to: user.email, subject: "You were invited to a Zeitkit team"
  end
end
