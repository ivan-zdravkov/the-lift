# frozen_string_literal: true

# The Commander will command the Elevator and what floors to stop at
class Commander
  def initialize(number_of_floors)
    @floors = []

    number_of_floors.times { |floor| @floors.push({ floor: floor, called: false }) }
  end

  def call_elevator(floor)
    @floors[floor].called = true
  end

  def reach_floor(floor)
    @floors[floor].called = false
  end
end
