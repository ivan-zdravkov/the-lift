# frozen_string_literal: true

# Defines the Directions the Elevator is moving on
module ElevatorDirection
  attr_reader :current_direction
  attr_reader :current_floor

  protected

  def dock?() end

  def dock() end

  def calls_from_above() end

  def calls_from_below() end

  def change_direction?() end

  def change_direction(new_direction) end
end
