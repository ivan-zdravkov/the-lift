# frozen_string_literal: true

# The Floor will keep the people and have a Command Interface to call the Elevator
class Floor
  attr_reader :number
  def initialize(number, people)
    @number = number
    @waiting = people
    @arrived = []
  end

  def give_person(direction)
    if direction == Direction::UP
      give_person_up
    elsif direction == Direction::DOWN
      give_person_down
    end
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

  private 

  def give_person_up
    person = @waiting.select { |p| p.destination_floor > @number }.first

    @waiting.delete(person) unless person.nil?

    person
  end

  def give_person_down
    person = @waiting.select { |p| p.destination_floor < @number }.first

    @waiting.delete(person) unless person.nil?

    person
  end
end
