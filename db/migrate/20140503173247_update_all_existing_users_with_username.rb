class UpdateAllExistingUsersWithUsername < ActiveRecord::Migration
  def up
    User.find_each do |user|
      user.username = User.unused_random_username
      user.save!
    end
  end

  def down
    User.update_all(username: nil)
  end
end
