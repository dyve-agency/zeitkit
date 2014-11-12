class InvoiceDecorator < Draper::Decorator
  delegate_all


  def hours_worked
    h.distance_of_time_in_words 0, (worklogs.map(&:duration).inject(:+) || 0).to_i, false
  end
end
