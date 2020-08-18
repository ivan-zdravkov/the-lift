# frozen_string_literal: true

# The Log we are putting on the console
class Log
  def initialize(floor, people, current_direction)
    @floor = floor
    @people = people
    @current_direction = current_direction
  end

  def format
    direction = 'O'

    if @current_direction == Direction::UP
      direction = '^'
    elsif @current_direction == Direction::DOWN
      direction = 'V'
    end

    direction + ' ' + @floor.to_s + ', [' + @people.join(', ') + ']'
  end
end
