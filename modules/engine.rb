# frozen_string_literal: true

# Defines the movements the Elevator does
module Engine
  attr_reader :current_direction
  attr_reader :current_floor

  def change_floor(people) end

  def arrive() end

  def stop_moving?(people) end

  def stop_moving() end
end
