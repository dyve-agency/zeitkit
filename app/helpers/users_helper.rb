module UsersHelper
  def self_destruct_counter
    return unless current_user
    destruct = current_user.self_destruct_in
    "#{destruct[:hours]} hour(s), #{destruct[:minutes]} minute(s) and #{destruct[:seconds]} second(s)"
  end
end
