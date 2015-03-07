class WorklogDecorator < Draper::Decorator
  decorates_association :timeframes

  delegate_all

  def duration_hours_minutes
    "#{duration_hours}:#{duration_minutes}"
  end

  def duration_hours
    if object.duration_hours.to_s.length > 1
      object.duration_hours
    else
      "0#{object.duration_hours}"
    end
  end

  def duration_minutes
    if object.duration_minutes.to_s.length > 1
      object.duration_minutes
    else
      "0#{object.duration_minutes}"
    end
  end
end
