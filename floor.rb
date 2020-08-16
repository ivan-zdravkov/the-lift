# frozen_string_literal: true

# The Floor will keep the people and have a Command Interface to call the Elevator
class Floor
  attr_reader :number
  def initialize(number, people)
    @number = number
    @waiting = people
    @arrived = []
  end

  def give_person
    if @waiting.length.positive?
      person = @waiting.shift

      person
    end

    nil
  end

  def get_person(person)
    @arrived.push(person)
  end

  def anyone_up?
    @waiting.any? { |person| person.destination_floor > @number }
  end

  def anyone_down?
    @waiting.any? { |person| person.destination_floor < @number }
  end
end
