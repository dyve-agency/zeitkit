class Tutorial

  attr_accessor :user

  def initialize(user)
    self.user = user
  end

  SCORES = {
    worklogs: 20,
    clients: 25,
    invoices: 15,
    notes: 10,
    no_demo_user: 30,
    team: 20
  }

  # Adds methods to return the score
  # clients_score
  # worklogs_score
  # notes_score
  # invoices_score
  # no_demo_user_score
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
      total_score += levels if send("completed_#{score}?")
    end
    total_score
  end

  def show_tutorial?
    SCORES.keys.any? do |score|
      !send("completed_#{score}?")
    end
  end

  def completed_clients?
    user.clients.present?
  end

  def completed_worklogs?
    user.worklogs.present?
  end

  def completed_notes?
    user.notes.present?
  end

  def completed_invoices?
    user.invoices.present?
  end

  def completed_no_demo_user?
    !user.demo?
  end

  def completed_team?
    user.teams.present?
  end

  def calc_completion_percentage
    (calc_level.to_f / max_level.to_f) * 100
  end

end
