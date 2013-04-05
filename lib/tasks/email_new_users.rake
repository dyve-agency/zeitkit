desc "This task is called by the Heroku scheduler add-on. It emails all users that are older than 30 minutes and have not yet received a signup email."
task :email_new_users => :environment do
  puts "Emailing users..."
  User.email_new_users
end
