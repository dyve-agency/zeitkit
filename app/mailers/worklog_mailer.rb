class WorklogMailer < ActionMailer::Base
  default from: "Zeitkit team <info@zeitkit.com>"

  def worklog_for_shared_client_created(worklog)
    @worklog  = worklog
    @user     = worklog.user
    @client   = worklog.client
    @owner    = @worklog.created_for_user
    @duration = "#{@worklog.duration_hours}:#{@worklog.duration_minutes}"
    mail to: @owner.email, subject: "[#{@client.name}]- #{@user.username} - Shared worklog created"
  end
end
