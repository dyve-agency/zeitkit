module ClientsHelper
  def is_shared?(client)
    !(current_user == client.user)
  end
end
