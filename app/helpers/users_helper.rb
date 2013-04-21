module UsersHelper

  def self_destruct_counter
    return unless current_user.demo?
    destruct = current_user.self_destruct_in
    "#{destruct[:hours]} hour(s), #{destruct[:minutes]} minute(s) and #{destruct[:seconds]} second(s)"
  end

  def show_tutorial?
    if (current_user && current_user.show_tutorial? && not_on_home? && session[:show_tutorial] != false) || session[:show_tutorial] && not_on_home? && current_user
      @tutorial ||= Tutorial.new(current_user)
    end
  end

end
