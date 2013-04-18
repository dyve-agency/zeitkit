class Tutorial

  attr_accessor :user

  def initialize(user)
    self.user = user
  end

  SCORES = {
    worklogs: 30,
    clients: 40,
    invoices: 20,
    notes: 10
  }

  # Adds methods which if the user has:
  # clients?
  # worklogs?
  # notes?
  # invoices
  SCORES.keys.each do |arg|
    method_name = (arg.to_s + "?").to_sym
    send :define_method, method_name do
      eval("user." + arg.to_s + ".any?")
    end
  end

  # Adds methods to return the score
  # clients_score
  # worklogs_score
  # notes_score
  # invoices_score
  SCORES.keys.each do |arg|
    method_name = (arg.to_s + "_score").to_sym
    send :define_method, method_name do
      SCORES[arg]
    end
  end

  def max_level
    SCORES.map{|key,val| val}.inject(:+)
  end

  def calc_level
    total_score = 0
    SCORES.each do |score, levels|
      total_score += levels if send((score.to_s + "?").to_sym)
    end
    total_score
  end

  def show_tutorial?
    SCORES.keys.any? do |score|
      !send((score.to_s + "?").to_sym)
    end
  end

end
