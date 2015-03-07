module UsersHelper

  def self_destruct_counter
    return unless current_user.demo?
    destruct = current_user.self_destruct_in
    "#{destruct[:hours]} hour(s), #{destruct[:minutes]} minute(s) and #{destruct[:seconds]} second(s)"
  end

  def tutorial
    if show_tutorial?
      @tutorial ||= Tutorial.new(current_user)
      render "layouts/tutorial"
    end
  end

  def show_tutorial?
    current_user && current_user.show_tutorial?
  end

end
