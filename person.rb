# frozen_string_literal: true

# The Person is the one Commanding and riding the Elevator to get to their destination Floor
class Person
  attr_reader :destination_floor
  def initialize(destination_floor)
    @destination_floor = destination_floor
  end
end
