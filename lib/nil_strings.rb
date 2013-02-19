module NilStrings
  # Requires a method nil_if_empty_strings in the model. It should contain a
  # list of symbols relating to the attributes of the model that shall be
  # updated.

  def self.included(base)
    base.before_validation :nil_if_empty_strings
  end

  def nil_if_empty_strings
    string_fields_to_nil.each do |f|
      field_val = self[f.to_s]
      if field_val != nil && field_val.length == 0
        self[f.to_s] = nil
      end
    end
  end

end
