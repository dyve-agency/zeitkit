class CreateHolidaySettingForExistingUsers < ActiveRecord::Migration
  def up
    User.all.each do |user|
      hs = HolidaySetting.new(user_id: user.id)
      hs.save
    end
  end

  def down
  end
end
