class PopulateUserToken < ActiveRecord::Migration
  def change
    User.all.each do |user|
      next if user.token.present?
      user.update_attribute(:token, SecureRandom.hex)
    end
  end
end
