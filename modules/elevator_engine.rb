# frozen_string_literal: true

# Defines the Directions the Elevator is moving on
module ElevatorEngine
  attr_reader :current_direction
  attr_reader :current_floor

  def change_floor(people) end

  def arrive() end

  def stop_moving?(people) end

  def stop_moving() end
end
