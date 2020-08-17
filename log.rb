# frozen_string_literal: true

# The Log we are putting on the console
class Log
  attr_reader :floor
  attr_reader :people
  def initialize(floor, people)
    @floor = floor
    @people = people
  end

  def format
    @floor.to_s + ', [' + @people.join(', ') + ']'
  end
end
