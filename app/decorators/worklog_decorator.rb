class WorklogDecorator < Draper::Decorator
  decorates_association :timeframes

  delegate_all
end
