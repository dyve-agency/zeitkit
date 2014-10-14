class Timeframe < ActiveRecord::Base
  attr_accessible :ended, :started, :worklog_id
end
