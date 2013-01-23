ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
  :address              => "mail.gandi.net",
  :port                 => 587,
  :domain               => "zeittracker.com",
  :user_name            => "info@zeittracker.com",
  :password             => ENV['ZEMAIL_PASSWORD'],
  :authentication       => "plain",
  :enable_starttls_auto => true
}
