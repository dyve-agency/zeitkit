class AddBerlinTimezoneToAllExistingUsers < ActiveRecord::Migration
  def change
    User.find_each do |user|
      user.update_attribute(:time_zone, 'Berlin')
    end
  end
end
