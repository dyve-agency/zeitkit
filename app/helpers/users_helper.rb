module UsersHelper
  def self_destruct_counter
    return unless current_user
    destruct = current_user.self_destruct_in
    "#{destruct[:hours]} hour(s), #{destruct[:minutes]} minute(s) and #{destruct[:seconds]} second(s)"
  end

  def show_demo_warning?
    current_user && current_user.demo? && !session[:hide_demo_warning]
  end
end
