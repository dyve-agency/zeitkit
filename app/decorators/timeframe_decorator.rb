class TimeframeDecorator < Draper::Decorator
  delegate_all

  def worklog_summary_text
    "#{started_formatted}-#{ended_formatted}"
  end

  def started_formatted
    h.l started, format: :worklog_summary
  end

  def ended_formatted
    h.l ended, format: :worklog_summary
  end

  def hours_minutes
    minutes       = (duration / 60) % 60
    hours         = duration / (60 * 60)
    h.hours_minutes_combined hours, minutes
  end

end
