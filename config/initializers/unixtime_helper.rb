class DateTime
  def to_unixtime
    self.to_i
  end
end

class Time
  def to_unixtime
    self.to_i
  end
end

class NilClass
  def to_unixtime
    nil
  end
end
