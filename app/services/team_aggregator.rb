class TeamAggregator
  RANGE_VALUES = %i[this_month last_month this_week last_week this_year last_year]
  include Virtus.model
  include ActiveModel::Model
  attribute :team
  attribute :start_date
  attribute :end_date
  attribute :specific_range
end
