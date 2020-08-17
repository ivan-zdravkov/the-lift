# frozen_string_literal: true

require_relative 'enums/direction.rb'
require_relative 'log'

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
        press_from_inside
      end
      log_write @commander.current_floor
    end
  end

  private

  def log_write(floor)
    log = Log.new(floor.number, @people.map(&:destination_floor))
    @log.push(log)
  end

  def leave_elevator(person)
    @people.delete(person)
    @commander.current_floor.get_person(person)
  end

  def unload_people
    @people
      .filter { |person| person.destination_floor == @commander.current_floor.number }
      .each { |person| leave_elevator(person) }
  end

  def load_people
    while @people.length < @capacity
      given_person = @commander.current_floor.give_person(@commander.current_direction)

      break if given_person.nil?

      @people.push(given_person)
    end
  end

  def press_from_inside
    @people.each { |person| @commander.call_floor(person.destination_floor) }
  end
end
