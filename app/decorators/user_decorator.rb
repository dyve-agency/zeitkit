class UserDecorator < Draper::Decorator
  delegate_all

  def time_worked_this_month
    worklogs.joins(:timeframes).where("timeframes.started >= ?", DateTime.now.beginning_of_month).map(&:duration).inject(0, :+).to_f
  end

  def time_worked_last_month
    worklogs.joins(:timeframes).where("timeframes.started >= ? AND ended <= ?", 1.month.ago.beginning_of_month, 1.month.ago.end_of_month).map(&:duration).inject(0, :+).to_f
  end

  def hours_this_month
    h.number_with_precision (time_worked_this_month / 3600), precision: 2
  end

  def hours_last_month
    h.number_with_precision (time_worked_last_month / 3600), precision: 2
  end

end
