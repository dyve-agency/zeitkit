ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
  :address              => "mail.gandi.net",
  :port                 => 587,
  :domain               => "zeitkit.com",
  :user_name            => "info@zeitkit.com",
  :password             => ENV['ZEMAIL_PASSWORD'],
  :authentication       => "plain",
  :enable_starttls_auto => true
}
