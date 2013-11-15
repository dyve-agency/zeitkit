set :output, "/tmp/zeitkit_cron.log"

every 10.minutes do
  rake "email_new_users"
end
