class UserSignupEmailSent < ActiveRecord::Migration
  def change
    add_column :users, :signup_email_sent, :boolean
  end
end
