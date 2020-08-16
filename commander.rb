# frozen_string_literal: true

require_relative 'modules/elevator_caller'
require_relative 'modules/disabled_floors'
require_relative 'modules/elevator_direction'
require_relative 'enums/direction'
require_relative 'caller'

# The Commander will command the Elevator and what floors to stop at
class Commander
  include ElevatorCaller
  include DisabledFloors
  include ElevatorDirection
  attr_reader :current_direction
  attr_reader :current_floor
  def initialize(floors)
    @floors = floors
    @current_floor = floors[0]
    @current_direction = Direction::UP
    @calls_up = []
    @calls_down = []

    populate_floors(floors)
  end

  def call_all
    @floors.each { |floor| call(floor) }
  end

  def call(floor)
    if floor.anyone_up? && @calls_up[floor.number].available
      @calls_up[floor.number].called = true
    end
    if floor.anyone_down? && @calls_down[floor.number].available
      @calls_down[floor.number].called = true
    end
  end

  def move_next_floor(people)
    call(@current_floor) # If anyone still left to travel on this floor, call the elevator again.

    if change_direction?(people)
      @current_floor = change_direction
    else
      if @current_direction == Direction::UP
        @current_floor = @calls_up.first { |call| call.called && call.floor.number > @current_floor.number }.floor
      elsif @current_direction == Direction::DOWN
        @current_floor = @calls_down.last { |call| call.called && call.floor.number < @current_floor.number }.floor
      end
    end
  end

  def arrive
    if @current_direction == Direction::UP
      @calls_up[@current_floor.number].called = false
    elsif @current_direction == Direction::DOWN
      @calls_down[@current_floor.number].called = false
    end
  end

  def dock?(people)
    people.none? && !calls_from_above && !calls_from_below
  end

  def dock
    @current_floor = @floors[0]
    @current_direction = Direction::NONE
  end

  private

  def disabled_floors_up
    [0]
  end

  def disabled_floors_down(number_of_floors)
    [number_of_floors]
  end

  def populate_floors(floors)
    disabled_floors_down = disabled_floors_down(floors.length)

    floors.each do |floor|
      @calls_up.push(Caller.new(floor, available: !disabled_floors_up.include?(floor)))
      @calls_down.push(Caller.new(floor, available: !disabled_floors_down.include?(floor)))
    end
  end

  def calls_from_above
    @calls_up.union(@calls_down).any? { |f| f.called && f.floor.number > @current_floor.number }
  end

  def calls_from_below
    @calls_up.union(@calls_down).any? { |f| f.called && f.floor.number < @current_floor.number }
  end

  def change_direction?(people)
    if @current_direction == Direction::UP
      people.none? && !calls_from_above
    elsif @current_direction == Direction::DOWN
      people.none? && !calls_from_below
    end
  end

  def change_direction
    if @current_direction == Direction::UP
      @current_direction = Direction::DOWN
      @calls_down.filter(&:called).max(&:floor.number)
    elsif @current_direction == Direction::DOWN
      @current_direction = DIRECTION::UP
      @calls_up.filter(&:called).min(&:floor.number)
    end
  end
end
