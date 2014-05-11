require 'active_support/core_ext'
require 'active_support/core_ext/module/aliasing'

class Range
  def step_with_duration(step_size = 1, &block)
    return to_enum(:step, step_size) unless block_given?

    # Defer to Range implementation for steps other than 1.hour etc
    return step_without_duration(step_size, &block) unless step_size.kind_of? ActiveSupport::Duration

    # Step components, eg { minutes: 3, seconds: 30 }
    parts = Hash[step_size.parts]

    # Interate
    time = self.begin
    while exclude_end? ? time < self.end : time <= self.end
      yield time
      time = time.advance parts
    end
  end
  alias_method_chain :step, :duration
end
