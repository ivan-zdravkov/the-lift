# frozen_string_literal: true

# The Elevator will move up and down floors, have a Commander Interface to select a floor and pick up people along the way
class Elevator
  def initialize(capacity, commander, floors)
    @capacity = capacity
    @floors = floors
    @current_floor = floors[0]
    @command = commander
  end

  def move
    puts 'Move The Elevator'
  end
end
