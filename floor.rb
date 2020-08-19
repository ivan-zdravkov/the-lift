# frozen_string_literal: true

require_relative 'modules/person_delivery'

# The Floor will keep the people and have a Command Interface to call the Elevator
class Floor
  include PersonDelivery
  attr_reader :number
  attr_reader :waiting
  attr_reader :arrived
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

  def anyone_waiting?
    @waiting.any?
  end

  private

  def give_person_up
    person = @waiting.detect { |p| p.destination_floor > @number }
    @waiting.delete(person) unless person.nil?
    person
  end

  def give_person_down
    person = @waiting.detect { |p| p.destination_floor < @number }
    @waiting.delete(person) unless person.nil?
    person
  end
end
