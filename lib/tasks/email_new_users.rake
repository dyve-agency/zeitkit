desc "Emails new users that did not receive an email yet."
task :email_new_users => :environment do
  puts "Emailing users..."
  User.email_new_users
end
