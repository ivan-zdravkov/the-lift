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
  attr_reader :previous_floor
  def initialize(floors)
    @floors = floors
    @current_floor = floors[0]
    @previous_floor = nil
    @current_direction = Direction::UP
    @calls_up = []
    @calls_down = []

    populate_floors(floors)
  end

  def call_all
    @floors.each { |floor| call(floor) }
  end

  def call(floor)
    @calls_up[floor.number].called = true if floor.anyone_up? && @calls_up[floor.number].available
    @calls_down[floor.number].called = true if floor.anyone_down? && @calls_down[floor.number].available
  end

  def call_floor(floor_number)
    if floor_number > @current_floor.number
      @calls_up[floor_number].called = true if @calls_up[floor_number].available
    elsif floor_number < @current_floor.number
      @calls_down[floor_number].called = true if @calls_down[floor_number].available
    end
  end

  def move_next_floor(people)
    @previous_floor = @current_floor

    if revert_at_maximum?(people)
      @current_floor = revert_at_maximum
    else
      if @current_direction == Direction::UP
        @current_floor = next_called_floor
      elsif @current_direction == Direction::DOWN
        @current_floor = previous_called_floor
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

  def call_from_floor_after_loaded
    call(@previous_floor) if @previous_floor.anyone_waiting?
  end

  def press_from_inside(people)
    people.each { |person| call_floor(person.destination_floor) }
  end

  def dock?(people)
    people.none? && !calls_from_above && !calls_from_below
  end

  def dock
    @current_floor = @floors[0]
    @current_direction = Direction::NONE
  end

  private

  def next_called_floor
    if @calls_up.any? { |call| call.called && call.floor.number > @current_floor.number }
      @calls_up.select { |call| call.called && call.floor.number > @current_floor.number }.first&.floor
    else
      @calls_up.select(&:called).first&.floor
    end
  end

  def previous_called_floor
    if @calls_down.any? { |call| call.called && call.floor.number < @current_floor.number }
      @calls_down.select { |call| call.called && call.floor.number < @current_floor.number }.last&.floor
    else
      @calls_down.select(&:called).last&.floor
    end
  end

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
    @calls_up.any?(&:called)
  end

  def calls_from_below
    @calls_down.any?(&:called)
  end

  def revert_at_maximum?(people)
    if @current_direction == Direction::UP
      people.none? && !calls_from_above
    elsif @current_direction == Direction::DOWN
      people.none? && !calls_from_below
    end
  end

  def revert_at_maximum
    if @current_direction == Direction::UP
      @current_direction = Direction::DOWN
      @calls_down.select(&:called).max { |a, b| a.floor.number <=> b.floor.number }.floor
    elsif @current_direction == Direction::DOWN
      @current_direction = Direction::UP
      @calls_up.select(&:called).min { |a, b| a.floor.number <=> b.floor.number }.floor
    end
  end
end
