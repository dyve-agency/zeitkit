class TeamAggregator
  include Virtus.model
  include ActiveModel::Model
  attribute :team
  attribute :start_date
  attribute :end_date
end
