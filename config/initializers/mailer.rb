ActionMailer::Base.delivery_method = :smtp

if Rails.env.development?
  ActionMailer::Base.smtp_settings = {
    address:              ENV['MAILER_ADDRESS'],
    port:                 ENV['MAILER_PORT']
  }
elsif Rails.env.production?
  ActionMailer::Base.smtp_settings = {
    :address              => ENV['MAILER_ADDRESS'],
    :port                 => ENV['MAILER_PORT'],
    :domain               => ENV['MAILER_DOMAIN'],
    :user_name            => ENV['MAILER_USERNAME'],
    :password             => ENV['MAILER_PASSWORD'],
    :authentication       => ENV['MAILER_AUTHENTICATION'],
    :enable_starttls_auto => true
  }
end

ActionMailer::Base.default from: "Zeitkit Mailer <#{ENV['MAILER_DEFAULT_FROM']}>"
