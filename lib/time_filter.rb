module TimeFilter
  # Provides scopes to filter results based on time.
  def self.included(base)
    base.extend(ClassMethods)
    base.class_eval do
      scope :today, where(created_at: Time.zone.now.midnight..Time.zone.now)
      scope :this_week, where(created_at: Time.zone.now.beginning_of_week..Time.zone.now)
      scope :this_month, where(created_at: Time.zone.now.beginning_of_month..Time.zone.now)
      scope :last_month, where(created_at: Time.zone.now.beginning_of_month..Time.zone.now.beginning_of_month - 1.month)
    end
  end

  module ClassMethods
  end

end
