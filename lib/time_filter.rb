module TimeFilter
  # Provides scopes to filter results based on time.
  def self.included(base)
    base.extend(ClassMethods)
    base.class_eval do
      scope :this_month, where("created_at >= ?", Time.now.beginning_of_month)
      scope :last_month, where("created_at < ? AND created_at >= ?", Time.now.beginning_of_month, Time.now.beginning_of_month - 1.month)
    end
  end

  module ClassMethods
  end

end
