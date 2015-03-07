# Preview all emails at http://localhost:3000/rails/mailers/team_mailer
class TeamMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/team_mailer/invite
  def invite
    TeamMailer.invite
  end

end
