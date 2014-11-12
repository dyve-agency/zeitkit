class InvoiceDecorator < Draper::Decorator
  delegate_all


  def hours_worked
    total_seconds = invoice.worklog_duration
    minutes       = (total_seconds / 60) % 60
    hours         = total_seconds / (60 * 60)
    h.hours_minutes_combined hours, minutes
  end
end
