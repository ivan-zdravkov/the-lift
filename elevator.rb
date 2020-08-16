# frozen_string_literal: true

require_relative 'enums/direction.rb'

# The Elevator will move up and down floors, have a Commander to select a floor and pick up people along the way
class Elevator
  attr_reader :log
  def initialize(capacity, commander)
    @capacity = capacity
    @commander = commander
    @people = []
    @log = []
  end

  def move
    until @commander.current_direction == Direction::NONE
      if @commander.dock?(@people)
        @commander.dock
      else
        @commander.move_next_floor(@people)
        @commander.arrive
        unload_people
        load_people
      end
      log_write @commander.current_floor
    end
  end

  private

  def log_write(floor)
    @log.push(floor.number)
  end

  def leave_elevator(person)
    @people.delete(person)
    @commander.current_floor.give_person(person)
  end

  def unload_people
    @people
      .filter { |person| person.destination_floor == @commander.current_floor.number }
      .each { |person| leave_elevator(person) }
  end

  def load_people
    true
  end
end
