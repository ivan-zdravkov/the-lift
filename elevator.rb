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

  def initial_load
    @commander.arrive
    load_people
    @commander.call_from_the_inside(@people)
    @commander.call_from_the_outside
    log_write
  end

  def move
    until @commander.current_direction == Direction::NONE
      if @commander.stop_moving?(@people)
        @commander.stop_moving
      else
        move_a_floor
      end

      log_write
    end
  end

  private

  def move_a_floor
    @commander.change_floor(@people)
    @commander.arrive
    unload_people
    load_people
    @commander.call_from_the_outside
    @commander.call_from_the_inside(@people)
  end

  def log_write
    if @commander.current_direction == Direction::NONE && @commander.previous_floor.number.zero?
      @log.last.current_direction = Direction::NONE
      return
    end

    log = Log.new(@commander.current_floor.number, @people.map(&:destination_floor), @commander.current_direction)

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
end
