# frozen_string_literal: true

# The Caller is the button pressed for the floor
class Caller
  attr_reader :floor
  attr_reader :available
  attr_reader :called
  attr_writer :called
  def initialize(floor, available)
    @floor = floor
    @available = available
    @called = false
  end
end
