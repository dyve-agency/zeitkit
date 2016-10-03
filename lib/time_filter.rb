module TimeFilter
  # Provides scopes to filter results based on time.
  def self.included(base)
    base.extend(ClassMethods)
    base.class_eval do
      scope :today, lambda {joins(:timeframes).having("MAX(timeframes.ended) >= ?", Time.zone.now.midnight).group("worklogs.id")}
      scope :this_week, lambda {joins(:timeframes).having("MAX(timeframes.ended) BETWEEN ? AND ?", Time.zone.now.beginning_of_week, Time.zone.now).group("worklogs.id")}
      scope :this_month, lambda {joins(:timeframes).having("MAX(timeframes.ended) BETWEEN ? AND ?", Time.zone.now.beginning_of_month, Time.zone.now).group("worklogs.id")}
      scope :older_than_this_month, lambda {joins(:timeframes).having("MAX(timeframes.ended) < ?", Time.zone.now.beginning_of_month).group("worklogs.id")}
      scope :last_month, lambda {joins(:timeframes).having("MAX(timeframes.ended) BETWEEN ? AND ?", (Time.zone.now.beginning_of_month - 1.month), Time.zone.now.beginning_of_month).group("worklogs.id")}
    end
  end

  module ClassMethods
  end

end
