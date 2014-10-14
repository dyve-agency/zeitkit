class CreateDurationForEveryWorklog < ActiveRecord::Migration
  def up
    Worklog.find_each do |wl|
      t = wl.timeframes.build
      t.started = wl.start_time
      t.ended = wl.end_time
      begin
      t.save!
      rescue => e
      end
    end
  end

  def down
    Timeframe.destroy_all
  end
end
