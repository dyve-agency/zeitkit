module ActiveModel
  class Errors
    def full_messages_joined(join_with: ", ")
      full_messages.join(join_with)
    end
  end
end
