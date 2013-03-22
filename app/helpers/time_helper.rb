module TimeHelper
  def today_us_parsed
    Time.zone.now.strftime("%m/%d/%Y")
  end
end
